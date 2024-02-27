# Create the Root group
root_group = Group.create!(
  name: 'Root',
  org_type: 'SomeOrgType'  # Make sure to replace 'SomeOrgType' with the appropriate organization type
)

# Create a user with email and assign them to the root group
User.create!(
  email: 'dallasocoggins@gmail.com',
  is_admin: true,
  group: root_group  # Use the object reference directly
)
