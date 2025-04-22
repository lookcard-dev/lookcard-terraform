resource "aws_account_primary_contact" "primary" {
  address_line_1     = "19A, Soundwill Plaza II Midtown"
  address_line_2     = "No:1-29 Tang Lung Street"
  address_line_3     = "Causeway Bay"
  city               = "Hong Kong"
  company_name       = "LookCard Limited"
  country_code       = "HK"
  district_or_county = "Hong Kong Island"
  full_name          = "Mike, Ng Sin Ching"
  phone_number       = "+85267631730"
  postal_code        = "000000"
  state_or_region    = "HK"
  website_url        = "https://www.lookcard.io"
}

resource "aws_account_alternate_contact" "operations" {
  alternate_contact_type = "OPERATIONS"
  name          = "Mike Ng"
  title         = "Chief Technology Officer"
  email_address = "mike.ng@lookcard.dev"
  phone_number  = "+85267631730"
}

resource "aws_account_alternate_contact" "security" {
  alternate_contact_type = "SECURITY"
  name          = "Mike Ng"
  title         = "Chief Technology Officer"
  email_address = "mike.ng@lookcard.dev"
  phone_number  = "+85267631730"
}

resource "aws_account_alternate_contact" "billing" {
  alternate_contact_type = "BILLING"
  name          = "Mike Ng"
  title         = "Chief Technology Officer"
  email_address = "mike.ng@lookcard.dev"
  phone_number  = "+85267631730"
}