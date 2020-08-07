# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'filter'

module Console
	# A general sink which captures all events into a buffer.
	class Capture
		def initialize
			@buffer = []
		end
		
		attr :events
		
		def last
			@buffer.last
		end
		
		def clear
			@buffer.clear
		end
		
		def verbose!(value = true)
		end
		
		def call(subject = nil, *arguments, severity: UNKNOWN, **options, &block)
			message = {
				time: ::Time.now.iso8601,
				severity: severity,
				**options,
			}
			
			if subject
				message[:subject] = subject
			end
			
			if arguments.any?
				message[:arguments] = arguments
			end
			
			if block_given?
				if block.arity.zero?
					message[:message] = yield
				else
					buffer = StringIO.new
					yield buffer
					message[:message] = buffer.string
				end
			end
			
			@buffer << message
		end
	end
end
