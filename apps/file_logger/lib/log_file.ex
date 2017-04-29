defmodule FileLogger.LogFile do

    @file_path Application.get_env(:logger, :file_path)
    @new_line "\r\n"
    
    def add(line) do
        case (if File.exists?(@file_path) do
            File.open(@file_path, [:append])
        else
            File.open(@file_path, [:write])
        end) do
            {:ok, _} ->
                File.write(@file_path, Poison.encode!(line) <> @new_line, [:append])
                File.close(@file_path)
            {:err, msg} ->
                IO.inspect("Cannot write to log file: " <> msg)
        end
    end
end