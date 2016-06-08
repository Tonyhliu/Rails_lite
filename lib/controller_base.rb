require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    # Next, write a method named redirect_to(url).
    # Issuing a redirect consists of two parts,
    # setting the 'Location' field of the response header
    # to the redirect url and setting the response status
    # code to 302. Do not use #redirect; set each piece of
    # the response individually. Check the Rack::Response
    # docs for how to set response header fields and statuses.
    # Again, set @already_built_response to avoid a double render.

    raise "Already redirected" if already_built_response?
    @res.header['Location'] = url
    @res.status = 302 #found
    @already_built_response = !@already_built_response
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already Rendered!" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    # debugger
    # @res.body.concat(content)
    @already_built_response = !@already_built_response
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)

  # Let's write a render(template_name) method that will:
  # Use the controller and template names to construct
  # the path to a template file.
  # Use File.read to read the template file.
  # Create a new ERB template from the contents.
  # Evaluate the ERB template, using binding to capture
  # the controller's instance variables.
  # Pass the result to render_content with a content_type of
  #  text/html.

  # We'll assume that any developers who use our framework
  # are aware of our template naming convention, which is as
  # follows: "views/#{controller_name}/#{template_name}.html.erb".
  # Use ActiveSupport's #underscore (require 'active_support/inflector')
  # method to convert the controller's class name to snake case.
  # We'll be lazy and not chop off the _controller bit at the end.

    dir_path = File.dirname(__FILE__) #file directory
    content = File.read("#{dir_path}/../views/#{self.class.name.underscore}/#{template_name}.html.erb")

    erb_template = ERB.new(content).result(binding)
    render_content(erb_template, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    # Add a method ControllerBase#invoke_action(action_name)
    # use send to call the appropriate action (like new or show)
    # check to see if a template was rendered;
    # if not call render in invoke_action.
    self.send(name)
    render(name) unless already_built_response?

   nil
  end
end
