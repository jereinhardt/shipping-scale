# ShippingScale

ShippingScale is a simple interface with the USPS Price Calculator API.  With it, you can quickly and easily calculate postage prices for packages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shipping-scale'

# or from the github repository
gem 'shipping-scale', :git => 'https://github.com/jereinhardt/shipping-scale.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shipping-scale

## Setup

In order to properly configure your interface, you must first have a registered developer account with the US Postal Service.  

Add an initializer to your application and configure it to use your API USER ID

```ruby 
ShippingScale.configure do |config|
  config.user_id = ENV["USPS_USER_ID"]
  config.timeout = 5
  config.testing = false
end
```

## Usage

If you have all of the necessary information for the package you want to ship, using the gem is as simple as creating an instance of `ShipingScale::Package` and using `#get_price!`.  Other details are also returned with this method.

```ruby
package_options = { 
  pounds: 1,
  ounces: 8, # or weight: 1.5
  zip_origin: "66204",
  zip_destination: "63501" 
}

package = ShippingScale::Package.new(package_options)

package.get_price!

# for the floating point value of postage
package.price # => 15

# for other details sent back from the request
package.details # => { zip_origination: "66204", zip_destination: "63501", pounds: "1", ... }
```
Currently, all rates retreived from the USPS API are for 2-day Priority Mail only.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Bug reports and pull requests are welcome on GitHub at https://github.com/jereinhardt/shipping-scale.


