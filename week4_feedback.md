- We've gone back to a rather imperative approach for preference filters, how can we fix this! (take a look at Ecto.Query.API.field)

- The empty_map? guard can be replaced by param === %{}

- Is the import for Ecto.Query in use in the accounts.ex? If so we should aim to move those calls out to the schema but I couldn't see a specific use, if using import `only: []` is vital!

- The errors being returned are more of a guard case in accounts.ex and actually should be done a level up in the resolver, this is because the context is not responsible for validating basic input is correct, that's a job of that layer up!