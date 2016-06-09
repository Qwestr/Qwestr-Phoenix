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

Copyright 2016 Qwestr

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
