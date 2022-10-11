defmodule Permify.RealtionshipTest do
  use Permify.HttpCase, async: true

  alias Permify.Relationship, as: Subject

  @relationship %{entity: %{id: "1", type: "organization"}, relation: "member", subject: %{id: "1", type: "user"}}

  @response Jason.decode!(Jason.encode!(@relationship))

  describe "read/2" do
    setup %{client: client} do
      Subject.write(client, @relationship)

      :ok
    end

    test "with valid request reads existing relationships", %{client: client} do
      assert {:ok, [@response]} == Subject.read(client, @relationship)
    end

    test "with invalid request returns error", %{client: client} do
      relationship = %{entity: %{id: "1", type: "toto"}, relation: "member", subject: %{id: "1", type: "user"}}

      assert {:ok, nil} == Subject.read(client, relationship)
    end
  end

  describe "write/2" do
    test "with valid request creates a new relationship", %{client: client, version: version} do
      assert {:ok, @response} == Subject.write(client, Map.put(@relationship, :schema_version, version))
    end

    test "with invalid request creates a new relationship", %{client: client, version: version} do
      relationship = %{entity: %{id: "1", type: "toto"}, relation: "member", subject: %{id: "1", type: "user"}}

      assert {:error, %{"relation" => "subject type is not found in defined types"}} ==
               Subject.write(client, Map.put(relationship, :schema_version, version))
    end

    test "with invalid schema version creates a new relationship", %{client: client} do
      assert {:error, %{"relation" => "subject type is not found in defined types"}} ==
               Subject.write(client, Map.put(@relationship, :schema_version, "aaa"))
    end
  end

  describe "delete/2" do
    setup %{client: client} do
      Subject.write(client, @relationship)

      :ok
    end

    test "with valid request creates a new relationship", %{client: client} do
      assert {:ok, @response} == Subject.delete(client, @relationship)
    end

    test "with invalid request creates a new relationship", %{client: client} do
      relationship = %{entity: %{id: "1", type: "toto"}, relation: "member", subject: %{id: "1", type: "user"}}

      assert {:ok, Jason.decode!(Jason.encode!(relationship))} == Subject.delete(client, relationship)
    end
  end
end
