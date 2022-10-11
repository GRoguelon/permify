# Permify

Permify is an Elixir client for the project [permify](https://www.permify.co/).

[Documentation](https://hexdocs.pm/permify)

## Installation

```elixir
def deps do
  [
    {:permify, "~> 0.1.0"}
  ]
end
```

## Usage

### Create a new client

```elixir
client = Permify.Client.new("http://localhost:3476/v1")
```

### Create a schema

```elixir
schema = """
entity user {}

entity organization {
    relation admin @user
    relation member @user

    action view_files = admin or member
    action edit_files = admin
}
"""

{:ok, schema_version} = Permify.Schema.write(client, schema)
```

### Create some relationships

```elixir
relationship = %{
  entity: %{id: "1", type: "organization"},
  relation: "member",
  subject: %{id: "1", type: "user"},
  schema_version: schema_version
}

Permify.Relationship.write(client, relationship)
```

### Check permissions

```elixir
{:ok, %{"can" => can}} = Permify.Permission.check?(client, %{
  action: "edit_files",
  depth: 0,
  entity: %{type: "organization", id: "1"},
  subject: %{id: "1", type: "user"}
})

IO.inspect(can, label: "Is authorized")
```
