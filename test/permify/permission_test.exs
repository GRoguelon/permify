defmodule Permify.PermissionTest do
  use Permify.HttpCase, async: true

  alias Permify.Permission, as: Subject

  @check_request %{
    action: "edit_files",
    depth: 0,
    entity: %{type: "organization", id: "1"},
    subject: %{id: "1", type: "user"}
  }

  describe "check?/2" do
    test "returns permissions", %{client: client, version: version} do
      assert Subject.check?(client, Map.put(@check_request, :schema_version, version))
    end
  end

  describe "check/2" do
    test "returns permissions", %{client: client, version: version} do
      assert {:ok,
              %{
                "can" => true,
                "decisions" => %{"organization:1#admin" => %{"can" => true, "prefix" => ""}},
                "remaining_depth" => 19
              }} == Subject.check(client, Map.put(@check_request, :schema_version, version))
    end
  end

  describe "expand/2" do
    test "returns details", %{client: client, version: version} do
      assert {:ok,
              %{
                "tree" => %{
                  "children" => [
                    %{
                      "children" => [
                        %{"kind" => "leaf", "subject" => %{"id" => "1", "type" => "user"}}
                      ],
                      "kind" => "branch",
                      "target" => %{
                        "entity" => %{"id" => "1", "type" => "organization"},
                        "relation" => "admin"
                      }
                    }
                  ],
                  "kind" => "expand",
                  "operation" => "root"
                }
              }} ==
               Subject.expand(client, %{
                 action: "edit_files",
                 entity: %{type: "organization", id: "1"},
                 schema_version: version
               })
    end
  end
end
