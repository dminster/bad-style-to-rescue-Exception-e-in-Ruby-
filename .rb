TL;DR: Use StandardError instead for general exception catching. When the original exception is re-raised (e.g. when rescuing to log the exception only), rescuing Exception is probably okay.

Exception is the root of Ruby's exception hierarchy, so when you rescue Exception you rescue from everything, including subclasses such as SyntaxError, LoadError, and Interrupt.

Rescuing Interrupt prevents the user from using CTRLC to exit the program.

Rescuing SignalException prevents the program from responding correctly to signals. It will be unkillable except by kill -9.

Rescuing SyntaxError means that evals that fail will do so silently.

All of these can be shown by running this program, and trying to CTRLC or kill it:

loop do
  begin
    sleep 1
    eval "djsakru3924r9eiuorwju3498 += 5u84fior8u8t4ruyf8ihiure"
  rescue Exception
    puts "I refuse to fail or be stopped!"
  end
end
Rescuing from Exception isn't even the default. Doing

begin
  # iceberg!
rescue
  # lifeboats
end
does not rescue from Exception, it rescues from StandardError. You should generally specify something more specific than the default StandardError, but rescuing from Exception broadens the scope rather than narrowing it, and can have catastrophic results and make bug-hunting extremely difficult.

If you have a situation where you do want to rescue from StandardError and you need a variable with the exception, you can use this form:

begin
  # iceberg!
rescue => e
  # lifeboats
end
which is equivalent to:

begin
  # iceberg!
rescue StandardError => e
  # lifeboats
end
One of the few common cases where it’s sane to rescue from Exception is for logging/reporting purposes, in which case you should immediately re-raise the exception:

begin
  # iceberg?
rescue Exception => e
  # do some logging
  raise # not enough lifeboats ;)
end
