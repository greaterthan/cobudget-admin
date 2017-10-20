defmodule CobudgetAdminWeb.PageView do
  use CobudgetAdminWeb, :view
  
  def group_age(created_at) do
    Timex.from_now(created_at)
  end

  def group_updated(updated_at) do
    if updated_at, do: Timex.from_now(updated_at), else: 'Never'
  end
end
