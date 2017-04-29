defmodule FileLogger do
  
  alias FileLogger.LogFile

  def append(line) do
    LogFile.add(line)
  end
end
