defmodule Permify.SchemaTest do
  use Permify.HttpCase, async: true

  alias Permify.Schema, as: Subject

  setup do
    schema = File.read!("test/support/schema.perm")

    {:ok, schema: schema}
  end

  describe "read/2" do
    test "with valid schema version returns the schema", %{client: client, version: version} do
      assert {:ok, %{"entities" => entities}} = Subject.read(client, version)
      assert is_map(entities)
    end

    test "with invalid schema version returns an error", %{client: client} do
      assert {:ok, %{"entities" => %{}}} == Subject.read(client, "aaa")
    end
  end

  describe "lookup/2" do
    test "with valid schema returns the schema", %{client: client, version: version} do
      assert {:ok, ["view_files", "edit_files"]} ==
               Subject.lookup(client, %{entity_type: "organization", relation_names: ["admin"], schema_version: version})
    end

    test "with invalid schema version returns an error", %{client: client} do
      assert {:ok, []} ==
               Subject.lookup(client, %{entity_type: "organization", relation_names: ["admin"], schema_version: "aaa"})
    end
  end

  describe "write/2" do
    test "with valid schema writes a new schema", %{client: client, schema: schema} do
      assert {:ok, schema_version} = Subject.write(client, schema)
      assert String.length(schema_version) == 20
    end

    test "with invalid schema returns error", %{client: client, schema: schema} do
      assert {:error, %{"schema" => "user entity required"}} ==
               Subject.write(client, String.slice(schema, 1, String.length(schema)))
    end
  end
end
