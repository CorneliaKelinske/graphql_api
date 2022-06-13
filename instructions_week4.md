Using the Phoenix project that was created last week, separate the data out from being a static list in a module, to using a context with two tables. 

The context should be named `Accounts` and should have two schemas`User` and `Preference`, set this up with graphql so that we can query for the data as well as have it persist inside our database when running mutations.

We should still be able to get our user's subscription to give us messages when users change their preferences.



Use EctoShorts to make this cleaner and also add filters for `before`/`after`/`first`, for this project we are not allowed to use relational filtering. This means we are not allowed to just pass

%{preferences: %{likes_email: true}}
into EctoShorts
