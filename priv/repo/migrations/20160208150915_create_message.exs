defmodule SingleVoiceMessage.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :url, :string

      timestamps
    end

  end
end
