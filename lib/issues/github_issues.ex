defmodule Issues.GithubIssues do
  @user_agent [{"User-Agent", "Elixir sebastian@github.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      check_for_error(status_code),
      Poison.Parser.parse!(body)
    }
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
