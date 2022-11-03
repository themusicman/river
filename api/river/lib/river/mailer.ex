defmodule River.Mailer do
  @moduledoc """
  The Mailer is responsible for sending emails.
  """
  use Swoosh.Mailer, otp_app: :river
end
