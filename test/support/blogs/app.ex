defmodule Blogs.App do
  @moduledoc false
  use Momo.App, otp_app: :momo

  app roles: "current_user.roles" do
    models do
      Blogs.Models.User
      Blogs.Models.Credential
      Blogs.Models.Onboarding
      Blogs.Models.Digest
      Blogs.Models.Author
      Blogs.Models.Blog
      Blogs.Models.Comment
      Blogs.Models.Post
      Blogs.Models.Theme
    end

    commands do
      Blogs.Commands.EnableUser
      Blogs.Commands.ExpireCredentials
      Blogs.Commands.RegisterUser
      Blogs.Commands.RemindPassword
      Blogs.Commands.RequestFeedback
      Blogs.Commands.SendWelcomeEmail
    end

    queries do
      Blogs.Queries.GetOnboardings
      Blogs.Queries.GetUserByEmail
      Blogs.Queries.GetUserIds
      Blogs.Queries.GetUsers
      Blogs.Queries.GetUsersByEmails
    end

    events do
      Blogs.Events.CredentialExpired
      Blogs.Events.PasswordRemindedSent
      Blogs.Events.UserOnboarded
      Blogs.Events.UserRegistered
      Blogs.Events.UsersLocked
    end

    flows do
      Blogs.Flows.Onboarding
    end

    subscriptions do
      Blogs.Subscriptions.UserOnboardings
      Blogs.Subscriptions.UserRegistrations
    end

    mappings do
      Blogs.Mappings.CredentialExpiredFromCredential
      Blogs.Mappings.UserIdFromMap
      Blogs.Mappings.UserRegisteredFromUser
    end

    values do
      Blogs.Values.UserEmail
      Blogs.Values.UserEmails
      Blogs.Values.UserId
    end

    scopes do
      Blogs.Scopes.IsPublic
      Blogs.Scopes.NotLocked
      Blogs.Scopes.Self
      Blogs.Scopes.SelfAndNotLocked
    end
  end
end
