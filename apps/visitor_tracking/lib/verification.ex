defmodule VisitorTracking.Verification do
  def create_sms_code(visitor_id, mobile_number) do
    {:ok, "123456"}
  end

  def create_link_token(visitor_id, email) do
    {:ok, "F7BC83F430538424B13298E6AA6FB143EF4D59A14946175997479DBC2D1A3CD8"}
  end

  def verify_sms_code(code, mobile_number) do
    {:ok, 1}
  end

  def verify_link_token(token) do
    {:ok, 1}
  end
end
