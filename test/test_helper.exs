ExUnit.start()

# Setup a fresh new schema for the tests.
{:ok, schema_version} = Permify.Schema.write(Permify.Client.new(), File.read!("test/support/schema.perm"))
Application.put_env(:permify, :schema_version, schema_version)
