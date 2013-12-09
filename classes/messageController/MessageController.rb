# Error messages are passed around as markdown, and are converted to HTML when needed.
# These messages are handled by this module.
class App < Sinatra::Base

	@@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)

	def self.markdown
		@@markdown
	end

	module MessageController

		def receive_message
			if !session[:messages].nil?
				@messages = session[:messages]
				flush_message
			else
				@messages = nil
			end
		end

		def store_message msg
			session[:messages] = msg
		end

		def flush_message
			session[:messages] = nil
		end

		def markdown_render msg
			App.markdown.render(msg)
		end
		
	end

	helpers MessageController

	before do
		receive_message
	end
end