let
  # Change this value when installing the configuration for another user.
  username = "oyatomo";
in
{
  inherit username;
  homeDirectory = "/home/${username}";
}
