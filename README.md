Use this Rack [middleware](http://railscasts.com/episodes/151-rack-middleware?view=asciicast) to redirect specified request paths to destination URLs by responding to the request with a ["301 Moved Permanently"](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/301) HTTP status code. When the request path is not a match, Redirect takes no action, and passes the request through to the app unaltered.

A middleware this simple has to exist already, but I couldn't find it.

For example, in a Rails 6 application, you could configure & set up this middleware like this:

```ruby
  config.middleware.insert_before ActionDispatch::Static,
    Redirect,
    redirect_map: {
      "/b" => "https://www.bhchp.org",
      "/imdb" => "https://www.imdb.com"
    }
```

If the user is requesting the paths "/b" or "/imdb" on your site, they are immediately redirected; any other path request is passed through to your Rails app.

In this example, the middleware is early enough in the middleware stack -- before [ActionDispatch::Static](https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/middleware/static.rb) -- that it will take effect before the standard Rails routing. This is my intended use case. Note: just as with any other middleware inserted so early, if Redirect passes the request through unaltered and the app throws an exception handling the request, Redirect may show up in the Rails stacktrace.

_Branch ['use_raw_rack_env'](https://github.com/houhoulis/redirect-middleware/tree/use_raw_rack_env) provides the same middleware except it uses the Rack environment variables directly rather than using the Rack::Request helper object._
