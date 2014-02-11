Sequel.migration do
  up do
    create_table :changelogger do
      primary_key :id
      DateTime :created_at
      Json :log
    end
  end

  down do
    drop_table(:changelogger)
  end
end
