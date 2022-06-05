Create a GraphQL API that uses the following static list of users and has queries, mutations and subscriptions for the examples below:



@users [%{
  id: 1,
  name: "Bill",
  email: "bill@gmail.com",
  preferences: %{
    likes_emails: false,
    likes_phone_calls: true,
    likes_faxes: true
  }
}, %{
  id: 2,
  name: "Alice",
  email: "alice@gmail.com",
  preferences: %{
    likes_emails: true,
    likes_phone_calls: false,
    likes_faxes: true
  }
}, %{
  id: 3,
  name: "Jill",
  email: "jill@hotmail.com",
  preferences: %{
    likes_emails: true,
    likes_phone_calls: true,
    likes_faxes: false
  }
}, %{
  id: 4,
  name: "Tim",
  email: "tim@gmail.com",
  preferences: %{
    likes_emails: false,
    likes_phone_calls: false,
    likes_faxes: false
  }
}]




User Query
query {
  user(id: 1) {
    id
    name
    email
		
    preferences {
      likesEmails
      likesPhoneCalls
      likesFaxes
    }
  }
}




Users Query
None of these parameters should be required (no NON_NULL)



query {
  users(likesEmails: true, likesPhoneCalls: false, likesFaxes: false) {
    id
    name
    email
		
    preferences {
      likesEmails
      likesPhoneCalls
      likesFaxes
    }
  }
}




Create User Mutation
In the case of creating it's ok to use one mutation since we don't know if it will fail to create a user or not and would cause 2 mutations otherwise

mutation {
  createUser(id: 1, name: "test", email: "new email", preferences: {
    likesEmails: true, 
    likesPhoneCalls: false,
    likesFaxes: true
  }) {
    id
    name
    email
		
    preferences {
      likesEmails
      likesPhoneCalls
      likesFaxes
    }
  }
}


Update User Mutation
mutation {
  updateUser(id: 1, name: "test", email: "new email") {
    id
    name
    email
		
    preferences {
      likesEmails
      likesPhoneCalls
      likesFaxes
    }
  }
}




Update User Preferences Mutation
Only one of these preferences should be required to update

mutation {
  updateUserPreferences(
    userId: 1,
    likesEmails: true, 
    likesPhoneCalls: false, 
    likesFaxes: true
  ) {
    likesEmails
    likesPhoneCalls
    likesFaxes
  }
}


Create User Subscription Mutation
subscription {
  createdUser {
    id
    name
    email
		
    preferences {
      likesEmails
      likesPhoneCalls
      likesFaxes
    }
  }
}


Update User Preferences Subscription
Hint: Because the user_id isn't present in the subscription trigger, you'll have to add it manually to the return of the updateUserPreferences mutation so that you can fetch the user_id inside the subscription trigger

subscription {
  updatedUserPreferences(userId: 1) {
    likesEmails
    likesPhoneCalls
    likesFaxes
  }
}
