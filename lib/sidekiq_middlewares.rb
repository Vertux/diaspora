module SidekiqMiddlewares
  class CleanAndShortBacktraces
    def call(worker, item, queue)
      yield
    rescue Exception
      backtrace = Rails.backtrace_cleaner.clean($!.backtrace)
      backtrace.reject! { |line| line =~ /lib\/sidekiq_middlewares.rb/ }
      limit = AppConfig.environment.sidekiq.backtrace.get
      limit = limit ? limit.to_i : 0
      backtrace = [] if limit == 0
      raise $!, $!.message, backtrace[0..limit]
    end
  end

  # From http://blog.krasnoukhov.com/posts/2013/01/07/profiling-memory-leaky-sidekiq-applications-with-ruby-2.1.html
  class Profiler
    # Number of jobs to process before reporting
    JOBS = 100

    class << self
      mattr_accessor :counter
      self.counter = 0

      def synchronize(&block)
        @lock ||= Mutex.new
        @lock.synchronize(&block)
      end

      def enable
        require "objspace"
        ObjectSpace.trace_object_allocations_start
        Sidekiq.logger.info "allocations tracing enabled"
      end
    end

    def call(worker_instance, item, queue)
      begin
        yield
      ensure
        self.class.synchronize do
          self.class.counter += 1

          if self.class.counter % JOBS == 0
            Sidekiq.logger.info "reporting allocations after #{self.class.counter} jobs"
            GC.start
            ObjectSpace.dump_all(output: File.open("heap.json", "w"))
            Sidekiq.logger.info "heap saved to heap.json"
          end
        end
      end
    end
  end
end
