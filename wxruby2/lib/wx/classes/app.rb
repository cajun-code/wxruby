# Copyright 2004-2006 by Kevin Smith
# released under the MIT-style wxruby2 license

# Controller class which creates and manages all windows.
class Wx::App
  # Convenience class method to create simple apps. Starts an
  # application main_loop, setting up initial windows etc as specified
  # in the passed block.
  # block 
  def self.run(&block)
    app_klass = Class.new(self)
    app_klass.class_eval do
      define_method(:on_init, &block)
    end
    the_app = app_klass.new
    the_app.main_loop
  end

  # This is a class method in Wx, but permit it to be an instance method
  # in wxRuby
  def is_main_loop_running
    Wx::App.is_main_loop_running
  end

  # This method handles failed assertions from within the WxWidgets C++
  # code. These messages are only generated by a DEBUG build of
  # WxRuby. Such messages usually indicate that the API is being used
  # incorrectly; the file/line reference points to the place in the
  # WxWidgets source code where the assertion was made.
  define_method(:on_assert_failure) do | file, line, condition, message |
    warn "Wx WARNING: #{message} (#{file}:#{line})"
  end

  # For use in development only, of no practical use in production code.
  # This method causes Ruby's garbage collection to run (roughly) at
  # interval +interval+ (seconds) - the default is 1, i.e. every
  # second. This should help ferret out bugs in memory management more
  # quickly.
  def gc_stress(interval = 1)
    # Ruby 1.9 provides this built-in version, but doesn't like the 1.8
    # version at all - results in frequent segfaults.
    if RUBY_VERSION >= "1.9.0"
      GC.stress
    else # Ruby 1.8
      t = Wx::Timer.new(self, 9999)
      evt_timer(9999) { Thread.pass }
      Thread.new { loop { sleep interval; GC.start } }
      t.start(100)
    end
  end
end
