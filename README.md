# Qwestr

A live version of the app can be found at:

https://qwestr.herokuapp.com

To run your own development version of app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Contributions

Contributing to the source code would be very much appreciated!

Here's a list of some changes that would help improve the app:

- Creation of sub-qwests (which could also contain sub-qwests)
- Allowing a user to share/ assign qwests to other users
- Tracking how many times a repeatable qwest has been completed
- Creation of a qwest description field and WYSIWYG editor for the field
- General code cleanup

## License

Copyright © 2016-2017 Qwestr LLC. This source code is licensed under the MIT
license found in the [LICENSE.txt](https://github.com/Qwestr/Qwestr-Phoenix/blob/master/LICENSE.txt)
file. The documentation to the project is licensed under the
[CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) license.

---
Made with ♥ by Shawn Daichendt ([@shawndaichendt](https://twitter.com/shawndaichendt)) and [contributors](https://github.com/Qwestr/Qwestr-Phoenix/graphs/contributors)
