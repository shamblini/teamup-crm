# Create the Root group
root_group = Group.create!(
  name: 'Root',
  org_type: 'SomeOrgType'  # Make sure to replace 'SomeOrgType' with the appropriate organization type
)

# Create a user with email and assign them to the root group
User.create!(
  email: 'dallasocoggins@gmail.com',
  user_type: 'staff',
  group: root_group  # Use the object reference directly
)

# Create a user with email and assign them to the root group
User.create!(
  email: 'dallasocoggins@tamu.edu',
  user_type: 'donor',
  group: root_group  # Use the object reference directly
)
