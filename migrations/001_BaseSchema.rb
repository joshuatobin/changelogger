Sequel.migration do
  up do
    create_table :changelogger do
      primary_key :id
      DateTime :created_at
      Json :log
      # TODO: We need to figure out how to add an index to the Json type
      # index :log # This doesn't work 
    end
  end

  down do
    drop_table(:changelogger)
  end
end
