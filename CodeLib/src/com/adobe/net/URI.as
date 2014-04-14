/*
  Copyright (c) 2008, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.net
{
	import flash.utils.ByteArray;
	
	/**
	 * This class implements functions and utilities for working with URI's
	 * (Universal Resource Identifiers).  For technical description of the
	 * URI syntax, please see RFC 3986 at http://www.ietf.org/rfc/rfc3986.txt
	 * or do a web search for "rfc 3986".
	 * 
	 * <p>The most important aspect of URI's to understand is that URI's
	 * and URL's are not strings.  URI's are complex data structures that
	 * encapsulate many pieces of information.  The string version of a
	 * URI is the serialized representation of that data structure.  This
	 * string serialization is used to provide a human readable
	 * representation and a means to transport the data over the network
	 * where it can then be parsed back into its' component parts.</p>
	 * 
	 * <p>URI's fall into one of three categories:
	 * <ul>
	 *  <li>&lt;scheme&gt;:&lt;scheme-specific-part&gt;#&lt;fragment&gt;		(non-hierarchical)</li>
	 *  <li>&lt;scheme&gt;:<authority&gt;&lt;path&gt;?&lt;query&gt;#&lt;fragment&gt;	(hierarchical)</li>
	 *  <li>&lt;path&gt;?&lt;query&gt;#&lt;fragment&gt;						(relative hierarchical)</li>
	 * </ul></p>
	 * 
	 * <p>The query and fragment parts are optional.</p>
	 * 
	 * <p>This class supports both non-hierarchical and hierarchical URI's</p>
	 * 
	 * <p>This class is intended to be used "as-is" for the vast majority
	 * of common URI's.  However, if your application requires a custom
	 * URI syntax (e.g. custom query syntax or special handling of
	 * non-hierarchical URI's), this class can be fully subclassed.  If you
	 * intended to subclass URI, please see the source code for complete
	 * documation on protected members and protected fuctions.</p>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0 
	 */
	public class URI
	{	
		// Here we define which characters must be escaped for each
		// URI part.  The characters that must be escaped for each
		// part differ depending on what would cause ambiguous parsing.
		// RFC 3986 sec. 2.4 states that characters should only be
		// encoded when they would conflict with subcomponent delimiters.
		// We don't want to over-do the escaping.  We only want to escape
		// the minimum needed to prevent parsing problems.
		
		// space and % must be escaped in all cases.  '%' is the delimiter
		// for escaped characters.
		public static const URImustEscape:String =	" %";
		
		// Baseline of what characters must be escaped
		public static const URIbaselineEscape:String = URImustEscape + ":?#/@";
		
		// Characters that must be escaped in the part part.
		public static const URIpathEscape:String = URImustEscape + "?#";
		
		// Characters that must be escaped in the query part, if setting
		// the query as a whole string.  If the query is set by
		// name/value, URIqueryPartEscape is used instead.
		public static const URIqueryEscape:String = URImustEscape + "#";
		
		// This is what each name/value pair must escape "&=" as well
		// so they don't conflict with the "param=value&param2=value2"
		// syntax.
		public static const URIqueryPartEscape:String = URImustEscape + "#&=";
		
		// Non-hierarchical URI's can have query and fragment parts, but
		// we also want to prevent '/' otherwise it might end up looking
		// like a hierarchical URI to the parser.
		public static const URInonHierEscape:String = 	URImustEscape + "?#/";
		
		// Baseline uninitialized setting for the URI scheme.
		public static const UNKNOWN_SCHEME:String = "unknown";
		
		// The following bitmaps are used for performance enhanced
		// character escaping.
		
		// Baseline characters that need to be escaped.  Many parts use
		// this.
		protected static const URIbaselineExcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URIbaselineEscape);
		
		// Scheme escaping bitmap
		protected static const URIschemeExcludedBitmap:URIEncodingBitmap = 
			URIbaselineExcludedBitmap;
		
		// User/pass escaping bitmap
		protected static const URIuserpassExcludedBitmap:URIEncodingBitmap =
			URIbaselineExcludedBitmap;
		
		// Authority escaping bitmap
		protected static const URIauthorityExcludedBitmap:URIEncodingBitmap =
			URIbaselineExcludedBitmap;
			
		// Port escaping bitmap
		protected static const URIportExludedBitmap:URIEncodingBitmap = 
			URIbaselineExcludedBitmap;
		
		// Path escaping bitmap
		protected static const URIpathExcludedBitmap:URIEncodingBitmap =
		 	new URIEncodingBitmap(URIpathEscape);
			
		// Query (whole) escaping bitmap
		protected static const URIqueryExcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URIqueryEscape);
			
		// Query (individual parts) escaping bitmap
		protected static const URIqueryPartExcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URIqueryPartEscape);
			
		// Fragments are the last part in the URI.  They only need to
		// escape space, '#', and '%'.  Turns out that is what query
		// uses too.
		protected static const URIfragmentExcludedBitmap:URIEncodingBitmap =
			URIqueryExcludedBitmap;
			
		// Characters that need to be escaped in the non-hierarchical part
		protected static const URInonHierexcludedBitmap:URIEncodingBitmap =
			new URIEncodingBitmap(URInonHierEscape);
			
		// Values used by getRelation()
		public static const NOT_RELATED:int = 0;
		public static const CHILD:int = 1;
		public static const EQUAL:int = 2;
		public static const PARENT:int = 3;

		//-------------------------------------------------------------------
		// protected class members
		//-------------------------------------------------------------------
		protected var _valid:Boolean = false;
		protected var _relative:Boolean = false;
		protected var _scheme:String = "";
		protected var _authority:String = "";
		protected var _username:String = "";
		protected var _password:String = "";
		protected var _port:String = "";
		protected var _path:String = "";
		protected var _query:String = "";
		protected var _fragment:String = "";
		protected var _nonHierarchical:String = "";
		protected static var _resolver:IURIResolver = null;


		/**
		 *  URI Constructor.  If no string is given, this will initialize
		 *  this URI object to a blank URI.
		 */
		public function URI(uri:String = null) : void	
		{
			if (uri == null)
				initialize();
			else
				constructURI(uri);
		}

		
		/**
		 * @private
		 * Method that loads the URI from the given string.
		 */
		protected function constructURI(uri:String) : Boolean
		{
			if (!parseURI(uri))
				_valid = false;
				
			return isValid();
		}
		
		
		/**
		 * @private Private initializiation.
		 */
		protected function initialize() : void
		{
			_valid = false;
			_relative = false;
		
			_scheme = UNKNOWN_SCHEME;
			_authority = "";
			_username = "";
			_password = "";
			_port = "";
			_path = "";
			_query = "";
			_fragment = "";
		
			_nonHierarchical = "";
		}	
		
		/**
		 * @private Accessor to explicitly set/get the hierarchical
		 * state of the URI.
		 */
		protected function set hierState(state:Boolean) : void
		{
			if (state)
			{
				// Clear the non-hierarchical data
				_nonHierarchical = "";
		
				// Also set the state vars while we are at it
				if (_scheme == "" || _scheme == UNKNOWN_SCHEME)
					_relative = true;
				else
					_relative = false;
		
				if (_authority.length == 0 && _path.length == 0)
					_valid = false;
				else
					_valid = true;
			}
			else
			{
				// Clear the hierarchical data
				_authority = "";
				_username = "";
				_password = "";
				_port = "";
				_path = "";
		
				_relative = false;
		
				if (_scheme == "" || _scheme == UNKNOWN_SCHEME)
					_valid = false;
				else
					_valid = true;
			}
		}
		protected function get hierState() : Boolean
		{
			return (_nonHierarchical.length == 0);
		}
		
		
		/**
		 * @private Functions that performs some basic consistency validation.
		 */
		protected function validateURI() : Boolean
		{
			// Check the scheme
			if (isAbsolute())
			{
				if (_scheme.length <= 1 || _scheme == UNKNOWN_SCHEME)
				{
					// we probably parsed a C:\ type path or no scheme
					return false;
				}
				else if (verifyAlpha(_scheme) == false)
					return false;  // Scheme contains bad characters
			}
			
			if (hierState)
			{
				if (_path.search('\\') != -1)
					return false;  // local path
				else if (isRelative() == false && _scheme == UNKNOWN_SCHEME)
					return false;  // It's an absolute URI, but it has a bad scheme
			}
			else
			{
				if (_nonHierarchical.search('\\') != -1)
					return false;  // some kind of local path
			}
		
			// Looks like it's ok.
			return true;
		}
		
		
		/**
		 * @private
		 *
		 * Given a URI in string format, parse that sucker into its basic
		 * components and assign them to this object.  A URI is of the form:
		 *    <scheme>:<authority><path>?<query>#<fragment>
		 *
		 * For simplicity, we parse the URI in the following order:
		 * 		
		 *		1. Fragment (anchors)
		 * 		2. Query	(CGI stuff)
		 * 		3. Scheme	("http")
		 * 		4. Authority (host name)
		 * 		5. Username/Password (if any)
		 * 		6. Port		(server port if any)
		 *		7. Path		(/homepages/mypage.html)
		 *
		 * The reason for this order is to minimize any parsing ambiguities.
		 * Fragments and queries can contain almost anything (they are parts
		 * that can contain custom data with their own syntax).  Parsing
		 * them out first removes a large chance of parsing errors.  This
		 * method expects well formed URI's, but performing the parse in
		 * this order makes us a little more tolerant of user error.
		 * 
		 * REGEXP
		 * Why doesn't this use regular expressions to parse the URI?  We
		 * have found that in a real world scenario, URI's are not always
		 * well formed.  Sometimes characters that should have been escaped
		 * are not, and those situations would break a regexp pattern.  This
		 * function attempts to be smart about what it is parsing based on
		 * location of characters relative to eachother.  This function has
		 * been proven through real-world use to parse the vast majority
		 * of URI's correctly.
		 *
		 * NOTE
		 * It is assumed that the string in URI form is escaped.  This function
		 * does not escape anything.  If you constructed the URI string by
		 * hand, and used this to parse in the URI and still need it escaped,
		 * call forceEscape() on your URI object.
		 *
		 * Parsing Assumptions
		 * This routine assumes that the URI being passed is well formed.
		 * Passing things like local paths, malformed URI's, and the such
		 * will result in parsing errors.  This function can handle
		 * 	 - absolute hierarchical (e.g. "http://something.com/index.html),
		 *   - relative hierarchical (e.g. "../images/flower.gif"), or
		 *   - non-hierarchical URIs (e.g. "mailto:jsmith@fungoo.com").
		 * 
		 * Anything else will probably result in a parsing error, or a bogus
		 * URI object.
		 * 
		 * Note that non-hierarchical URIs *MUST* have a scheme, otherwise
		 * they will be mistaken for relative URI's.
		 * 
		 * If you are not sure what is being passed to you (like manually
		 * entered text from UI), you can construct a blank URI object and
		 * call unknownToURI() passing in the unknown string.
		 * 
		 * @return	true if successful, false if there was some kind of
		 * parsing error
		 */
		protected function parseURI(uri:String) : Boolean
		{
			var baseURI:String = uri;
			var index:int, index2:int;
		
			// Make sure this object is clean before we start.  If it was used
			// before and we are now parsing a new URI, we don't want any stale
			// info lying around.
			initialize();
		
			// Remove any fragments (anchors) from the URI
			index = baseURI.indexOf("#");
			if (index != -1)
			{
				// Store the fragment piece if any
				if (baseURI.length > (index + 1)) // +1 is to skip the '#'
					_fragment = baseURI.substr(index + 1, baseURI.length - (index + 1)); 
		
				// Trim off the fragment
				baseURI = baseURI.substr(0, index);
			}
		
			// We need to strip off any CGI parameters (eg '?param=bob')
			index = baseURI.indexOf("?");
			if (index != -1)
			{
				if (baseURI.length > (index + 1))
					_query = baseURI.substr(index + 1, baseURI.length - (index + 1)); // +1 is to skip the '?'
		
				// Trim off the query
				baseURI = baseURI.substr(0, index);
			}
		
			// Now try to find the scheme part
			index = baseURI.search(':');
			index2 = baseURI.search('/');
		
			var containsColon:Boolean = (index != -1);
			var containsSlash:Boolean = (index2 != -1);
		
			// This value is indeterminate if "containsColon" is false.
			// (if there is no colon, does the slash come before or
			// after said non-existing colon?)
			var colonBeforeSlash:Boolean = (!containsSlash || index < index2);
		
			// If it has a colon and it's before the first slash, we will treat
			// it as a scheme.  If a slash is before a colon, there must be a
			// stray colon in a path or something.  In which case, the colon is
			// not the separator for the scheme.  Technically, we could consider
			// this an error, but since this is not an ambiguous state (we know
			// 100% that this has no scheme), we will keep going.
			if (containsColon && colonBeforeSlash)
			{
				// We found a scheme
				_scheme = baseURI.substr(0, index);
				
				// Normalize the scheme
				_scheme = _scheme.toLowerCase();
		
				baseURI = baseURI.substr(index + 1);
		
				if (baseURI.substr(0, 2) == "//")
				{
					// This is a hierarchical URI
					_nonHierarchical = "";
		
					// Trim off the "//"
					baseURI = baseURI.substr(2, baseURI.length - 2);
				}
				else
				{
					// This is a non-hierarchical URI like "mailto:bob@mail.com"
					_nonHierarchical = baseURI;
		
					if ((_valid = validateURI()) == false)
						initialize();  // Bad URI.  Clear it.
		
					// No more parsing to do for this case
					return isValid();
				}
			}
			else
			{
				// No scheme.  We will consider this a relative URI
				_scheme = "";
				_relative = true;
				_nonHierarchical = "";
			}
		
			// Ok, what we have left is everything after the <scheme>://
		
			// Now that we have stripped off any query and fragment parts, we
			// need to split the authority from the path
		
			if (isRelative())
			{
				// Don't bother looking for the authority.  It's a relative URI
				_authority = "";
				_port = "";
				_path = baseURI;
			}
			else
			{
				// Check for malformed UNC style file://///server/type/path/
				// By the time we get here, we have already trimmed the "file://"
				// so baseURI will be ///server/type/path.  If baseURI only
				// has one slash, we leave it alone because that is valid (that
				// is the case of "file:///path/to/file.txt" where there is no
				// server - implicit "localhost").
				if (baseURI.substr(0, 2) == "//")
				{
					// Trim all leading slashes
					while(baseURI.charAt(0) == "/")
						baseURI = baseURI.substr(1, baseURI.length - 1);
				}
		
				index = baseURI.search('/');
				if (index == -1)
				{
					// No path.  We must have passed something like "http://something.com"
					_authority = baseURI;
					_path = "";
				}
				else
				{
					_authority = baseURI.substr(0, index);
					_path = baseURI.substr(index, baseURI.length - index);
				}
		
				// Check to see if the URI has any username or password information.
				// For example:  ftp://username:password@server.com
				index = _authority.search('@');
				if (index != -1)
				{
					// We have a username and possibly a password
					_username = _authority.substr(0, index);
		
					// Remove the username/password from the authority
					_authority = _authority.substr(index + 1);  // Skip the '@'
		
					// Now check to see if the username also has a password
					index = _username.search(':');
					if (index != -1)
					{
						_password = _username.substring(index + 1, _username.length);
						_username = _username.substr(0, index);
					}
					else
						_password = "";
				}
				else
				{
					_username = "";
					_password = "";
				}
		
				// Lastly, check to see if the authorty has a port number.
				// This is parsed after the username/password to avoid conflicting
				// with the ':' in the 'username:password' if one exists.
				index = _authority.search(':');
				if (index != -1)
				{
					_port = _authority.substring(index + 1, _authority.length);  // skip the ':'
					_authority = _authority.substr(0, index);
				}
				else
				{
					_port = "";
				}
				
				// Lastly, normalize the authority.  Domain names
				// are case insensitive.
				_authority = _authority.toLowerCase();
			}
		
			if ((_valid = validateURI()) == false)
				initialize();  // Bad URI.  Clear it
		
			return isValid();
		}
		
		
		/********************************************************************
		 * Copy function.
		 */
		public function copyURI(uri:URI) : void
		{
			this._scheme = uri._scheme;
			this._authority = uri._authority;
			this._username = uri._username;
			this._password = uri._password;
			this._port = uri._port;
			this._path = uri._path;
			this._query = uri._query;
			this._fragment = uri._fragment;
			this._nonHierarchical = uri._nonHierarchical;
		
			this._valid = uri._valid;
			this._relative = uri._relative;
		}
		
		
		/**
		 * @private
		 * Checks if the given string only contains a-z or A-Z.
		 */
		protected function verifyAlpha(str:String) : Boolean
		{
			var pattern:RegExp = /[^a-z]/;
			var index:int;
			
			str = str.toLowerCase();
			index = str.search(pattern);
			
			if (index == -1)
				return true;
			else
				return false;
		}
		
		/**
		 * Is this a valid URI?
		 * 
		 * @return true if this object represents a valid URI, false
		 * otherwise.
		 */
		public function isValid() : Boolean
		{ 
			return this._valid;
		}
		
		
		/**
		 * Is this URI an absolute URI?  An absolute URI is a complete, fully
		 * qualified reference to a resource.  e.g. http://site.com/index.htm
		 * Non-hierarchical URI's are always absolute.
		 */
		public function isAbsolute() : Boolean
		{ 
			return !this._relative;
		}
		
		
		/**
		 * Is this URI a relative URI?  Relative URI's do not have a scheme
		 * and only contain a relative path with optional anchor and query
		 * parts.  e.g. "../reports/index.htm".  Non-hierarchical URI's
		 * will never be relative.
		 */
		public function isRelative() : Boolean
		{ 
			return this._relative;
		}
		
		
		/**
		 * Does this URI point to a resource that is a directory/folder?
		 * The URI specification dictates that any path that ends in a slash
		 * is a directory.  This is needed to be able to perform correct path
		 * logic when combining relative URI's with absolute URI's to
		 * obtain the correct absolute URI to a resource.
		 * 
		 * @see URI.chdir
		 * 
		 * @return true if this URI represents a directory resource, false
		 * if this URI represents a file resource.
		 */
		public function isDirectory() : Boolean
		{
			if (_path.length == 0)
				return false;
		
			return (_path.charAt(path.length - 1) == '/');
		}
		
		
		/**
		 * Is this URI a hierarchical URI? URI's can be  
		 */
		public function isHierarchical() : Boolean
		{ 
			return hierState;
		}
				
		
		/**
		 * The scheme of the URI.
		 */
		public function get scheme() : String
		{ 
			return URI.unescapeChars(_scheme);
		}
		public function set scheme(schemeStr:String) : void
		{
			// Normalize the scheme
			var normalized:String = schemeStr.toLowerCase();
			_scheme = URI.fastEscapeChars(normalized, URI.URIschemeExcludedBitmap);
		}
		
		
		/**
		 * The authority (host) of the URI.  Only valid for
		 * hierarchical URI's.  If the URI is relative, this will
		 * be an empty string. When setting this value, the string
		 * given is assumed to be unescaped.  When retrieving this
		 * value, the resulting string is unescaped.
		 */
		public function get authority() : String
		{ 
			return URI.unescapeChars(_authority);
		}
		public function set authority(authorityStr:String) : void
		{
			// Normalize the authority
			authorityStr = authorityStr.toLowerCase();
			
			_authority = URI.fastEscapeChars(authorityStr,
				URI.URIauthorityExcludedBitmap);
			
			// Only hierarchical URI's can have an authority, make
			// sure this URI is of the proper format.
			this.hierState = true;
		}
		
		
		/**
		 * The username of the URI.  Only valid for hierarchical
		 * URI's.  If the URI is relative, this will be an empty
		 * string.
		 * 
		 * <p>The URI specification allows for authentication
		 * credentials to be embedded in the URI as such:</p>
		 * 
		 * <p>http://user:passwd&#64;host/path/to/file.htm</p>
		 * 
		 * <p>When setting this value, the string
		 * given is assumed to be unescaped.  When retrieving this
		 * value, the resulting string is unescaped.</p>
		 */
		public function get username() : String
		{
			return URI.unescapeChars(_username);
		}
		public function set username(usernameStr:String) : void
		{
			_username = URI.fastEscapeChars(usernameStr, URI.URIuserpassExcludedBitmap);
			
			// Only hierarchical URI's can have a username.
			this.hierState = true;
		}
		
		
		/**
		 * The password of the URI.  Similar to username.
		 * @see URI.username
		 */
		public function get password() : String
		{
			return URI.unescapeChars(_password);
		}
		public function set password(passwordStr:String) : void
		{
			_password = URI.fastEscapeChars(passwordStr,
				URI.URIuserpassExcludedBitmap);
			
			// Only hierarchical URI's can have a password.
			this.hierState = true;
		}
		
		
		/**
		 * The host port number.  Only valid for hierarchical URI's.  If
		 * the URI is relative, this will be an empty string. URI's can
		 * contain the port number of the remote host:
		 * 
		 * <p>http://site.com:8080/index.htm</p>
		 */
		public function get port() : String
		{ 
			return URI.unescapeChars(_port);
		}
		public function set port(portStr:String) : void
		{
			_port = URI.escapeChars(portStr);
			
			// Only hierarchical URI's can have a port.
			this.hierState = true;
		}
		
		
		/**
		 * The path portion of the URI.  Only valid for hierarchical
		 * URI's.  When setting this value, the string
		 * given is assumed to be unescaped.  When retrieving this
		 * value, the resulting string is unescaped.
		 * 
		 * <p>The path portion can be in one of two formats. 1) an absolute
		 * path, or 2) a relative path.  An absolute path starts with a
		 * slash ('/'), a relative path does not.</p>
		 * 
		 * <p>An absolute path may look like:</p>
		 * <listing>/full/path/to/my/file.htm</listing>
		 * 
		 * <p>A relative path may look like:</p>
		 * <listing>
		 * path/to/my/file.htm
		 * ../images/logo.gif
		 * ../../reports/index.htm
		 * </listing>
		 * 
		 * <p>Paths can be absolute or relative.  Note that this not the same as
		 * an absolute or relative URI.  An absolute URI can only have absolute
		 * paths.  For example:</p>
		 * 
		 * <listing>http:/site.com/path/to/file.htm</listing>
		 * 
		 * <p>This absolute URI has an absolute path of "/path/to/file.htm".</p>
		 * 
		 * <p>Relative URI's can have either absolute paths or relative paths.
		 * All of the following relative URI's are valid:</p>
		 * 
		 * <listing>
		 * /absolute/path/to/file.htm
		 * path/to/file.htm
		 * ../path/to/file.htm
		 * </listing>
		 */
		public function get path() : String
		{ 
			return URI.unescapeChars(_path);
		}
		public function set path(pathStr:String) : void
		{	
			this._path = URI.fastEscapeChars(pathStr, URI.URIpathExcludedBitmap);
		
			if (this._scheme == UNKNOWN_SCHEME)
			{
				// We set the path.  This is a valid URI now.
				this._scheme = "";
			}
		
			// Only hierarchical URI's can have a path.
			hierState = true;
		}
		
		
		/**
		 * The query (CGI) portion of the URI.  This part is valid for
		 * both hierarchical and non-hierarchical URI's.
		 * 
		 * <p>This accessor should only be used if a custom query syntax
		 * is used.  This URI class supports the common "param=value"
		 * style query syntax via the get/setQueryValue() and
		 * get/setQueryByMap() functions.  Those functions should be used
		 * instead if the common syntax is being used.
		 * 
		 * <p>The URI RFC does not specify any particular
		 * syntax for the query part of a URI.  It is intended to allow
		 * any format that can be agreed upon by the two communicating hosts.
		 * However, most systems have standardized on the typical CGI
		 * format:</p>
		 * 
		 * <listing>http://site.com/script.php?param1=value1&param2=value2</listing>
		 * 
		 * <p>This class has specific support for this query syntax</p>
		 * 
		 * <p>This common query format is an array of name/value
		 * pairs with its own syntax that is different from the overall URI
		 * syntax.  The query has its own escaping logic.  For a query part
		 * to be properly escaped and unescaped, it must be split into its
		 * component parts.  This accessor escapes/unescapes the entire query
		 * part without regard for it's component parts.  This has the
		 * possibliity of leaving the query string in an ambiguious state in
		 * regards to its syntax.  If the contents of the query part are
		 * important, it is recommended that get/setQueryValue() or
		 * get/setQueryByMap() are used instead.</p>
		 * 
		 * If a different query syntax is being used, a subclass of URI
		 * can be created to handle that specific syntax.
		 *  
		 * @see URI.getQueryValue, URI.getQueryByMap
		 */
		public function get query() : String
		{ 
			return URI.unescapeChars(_query);
		}
		public function set query(queryStr:String) : void
		{
			_query = URI.fastEscapeChars(queryStr, URI.URIqueryExcludedBitmap);
			
			// both hierarchical and non-hierarchical URI's can
			// have a query.  Do not set the hierState.
		}
		
		/**
		 * Accessor to the raw query data.  If you are using a custom query
		 * syntax, this accessor can be used to get and set the query part
		 * directly with no escaping/unescaping.  This should ONLY be used
		 * if your application logic is handling custom query logic and
		 * handling the proper escaping of the query part.
		 */
		public function get queryRaw() : String
		{
			return _query;
		}
		public function set queryRaw(queryStr:String) : void
		{
			_query = queryStr;
		}


		/**
		 * The fragment (anchor) portion of the URI.  This is valid for
		 * both hierarchical and non-hierarchical URI's.
		 */
		public function get fragment() : String
		{ 
			return URI.unescapeChars(_fragment);
		}
		public function set fragment(fragmentStr:String) : void
		{
			_fragment = URI.fastEscapeChars(fragmentStr, URIfragmentExcludedBitmap);

			// both hierarchical and non-hierarchical URI's can
			// have a fragment.  Do not set the hierState.
		}
		
		
		/**
		 * The non-hierarchical part of the URI.  For example, if
		 * this URI object represents "mailto:somebody@company.com",
		 * this will contain "somebody@company.com".  This is valid only
		 * for non-hierarchical URI's.  
		 */
		public function get nonHierarchical() : String
		{ 
			return URI.unescapeChars(_nonHierarchical);
		}
		public function set nonHierarchical(nonHier:String) : void
		{
			_nonHierarchical = URI.fastEscapeChars(nonHier, URInonHierexcludedBitmap);
			
			// This is a non-hierarchical URI.
			this.hierState = false;
		}
		
		
		/**
		 * Quick shorthand accessor to set the parts of this URI.
		 * The given parts are assumed to be in unescaped form.  If
		 * the URI is non-hierarchical (e.g. mailto:) you will need
		 * to call SetScheme() and SetNonHierarchical().
		 */
		public function setParts(schemeStr:String, authorityStr:String,
				portStr:String, pathStr:String, queryStr:String,
				fragmentStr:String) : void
		{
			this.scheme = schemeStr;
			this.authority = authorityStr;
			this.port = portStr;
			this.path = pathStr;
			this.query = queryStr;
			this.fragment = fragmentStr;

			hierState = true;
		}
		
		
		/**
		 * URI escapes the given character string.  This is similar in function
		 * to the global encodeURIComponent() function in ActionScript, but is
		 * slightly different in regards to which characters get escaped.  This
		 * escapes the characters specified in the URIbaselineExluded set (see class
		 * static members).  This is needed for this class to work properly.
		 * 
		 * <p>If a different set of characters need to be used for the escaping,
		 * you may use fastEscapeChars() and specify a custom URIEncodingBitmap
		 * that contains the characters your application needs escaped.</p>
		 * 
		 * <p>Never pass a full URI to this function.  A URI can only be properly
		 * escaped/unescaped when split into its component parts (see RFC 3986
		 * section 2.4).  This is due to the fact that the URI component separators
		 * could be characters that would normally need to be escaped.</p>
		 * 
		 * @param unescaped character string to be escaped.
		 * 
		 * @return	escaped character string
		 * 
		 * @see encodeURIComponent
		 * @see fastEscapeChars
		 */
		static public function escapeChars(unescaped:String) : String
		{
			// This uses the excluded set by default.
			return fastEscapeChars(unescaped, URI.URIbaselineExcludedBitmap);
		}
		

		/**
		 * Unescape any URI escaped characters in the given character
		 * string.
		 * 
		 * <p>Never pass a full URI to this function.  A URI can only be properly
		 * escaped/unescaped when split into its component parts (see RFC 3986
		 * section 2.4).  This is due to the fact that the URI component separators
		 * could be characters that would normally need to be escaped.</p>
		 * 
		 * @param escaped the escaped string to be unescaped.
		 * 
		 * @return	unescaped string.
		 */
		static public function unescapeChars(escaped:String /*, onlyHighASCII:Boolean = false*/) : String
		{
			// We can just use the default AS function.  It seems to
			// decode everything correctly
			var unescaped:String;
			unescaped = decodeURIComponent(escaped);
			return unescaped;
		}
		
		/**
		 * Performance focused function that escapes the given character
		 * string using the given URIEncodingBitmap as the rule for what
		 * characters need to be escaped.  This function is used by this
		 * class and can be used externally to this class to perform
		 * escaping on custom character sets.
		 * 
		 * <p>Never pass a full URI to this function.  A URI can only be prop.           x}lCC €lC(5    ..          x}lCC €lCá4    å›QâV‰N8—b s-Nof. p n g     ÿÿåüÍÅÕù~1PNG  Y]lCC  ehCâ4Œ‘" A›QâV‰N8—b s-Nof. p n g     ÿÿ¾üÍÅÕù~1PNG  Y]lC+C ¥TCêˆ™ç&                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 f=8Ö¦9nXk]o÷ 	¥gäHÁ#ÆÇöô Ü“cIÅ=:tJUq×QìËÊEg‡–VXk$ğÜsÉ#ü?â€Ç#­™Øğ4éK6Ï†ª‰éjÖ‘¡cOe†²#†z9Ÿéi".…A¿ä{vÁ%¡óàé‰ˆ)ëÂG wÖ¹msmiêµQÃ	«ÛyG’1&wiG,8õŠ¦j³ã5x48ÜŠS^$LO³Iãy`[»aPÃ _—Iíoaº §+ş¯ø®Ÿ¬ãFOµU©q,‚S	¼”é,Â’R7–"YT:²¬=—{™»ØèÕ¿ÉÒÅ½³óÏÙAûgJ*N¯†4˜Ô»ÈÒˆ`«i¥ıêiä§ii`UDYŠ]Î¤ô²K*€–á*Ìì5ùç:¯ÖJßØÆ‹ò ?áéÆŸi5wLtJºÚ(LF:dVHUœL¡UTj>¤gGÔ>Ñµç‚ÇÂ„)ˆG¯šfwj/Ê?ÿ vª*#OÛJ]
š„Gå6d,âåUHUÕrÀp öÁšòv:Ş ùp•:sJ# £ı^½g§ÙRˆBSLeñ;g‘%…æ¹Y[z –úÏMŠFu6?òõg˜…ÓçÔš~½\µ.=«WoÍKQW_µ·E¾ğmÜÅtÒšªªu#Ïˆ¨š .Z„¶—Œ,‘…š5fv—P»x2Œ'•Şš”ê=Ùéï¤—øKıßÜbƒp`ôõ_Ã¥©‚ª«”¢ª{
ìU}5$ÕXúÈø‘5#Zx&@½ì#Ê)öôÀ•h	5¯SaÛõP7‚’ŒITÏ¢š•å Ã?Ü;Ø2µŒ¶‹[xƒº£éÒ[HñÆWê`tÔûj²ah#ŠXde–?µ”«G9RÅRÌ<ªåck7ŠD’Á‘ÓKqCwŸ·‡Ûşn=Z2ïİåÔDÚGÏ$òÄï7–ypÌ–	iäuˆĞÅ%<R'.§PDrºMÑ¡BWöô©;xõ]ªÀŠ×À†§„±…IñiOÔÖE²FßRIl²».¾?êÿ Wøz¾¿˜éGE¶0XU© ?p¡|¥I]éAÉ<ßì}¹©kòõI6NOANïë¹ğÕõ{›:Vbæ‡Ï»`,òÑQÒÂ±RoêxáÛìà‰ióH±‹MX]QIs»y#Ü‘)©sZÒ£×üı4“ZH®2‡ÏÚ?Í×G¬Â¬MQ<sTËä—Õ<2G.™šè˜£5ŒjÜÉr­Ñ¼7eÌ`}I§Kí›
³
zÏRqıg$†œÈâh^¢hêœ(š,hò ¾uQ"Ñ¸+Â3^;t„w1>‰SOZŸğ´oÒ´¶‰~Ö?æéİ¶,TÎ
rĞ2Ç­…;ÌuşØDÓ³²§4a‰ HQµÕí¹f†
xQx•àX×ş+­´·Rá›Hô\!ÓÄjÉ–XÍ50oÚÔ»M,s¨Œ™Şk¶¿Uôpn/t²^ŞÊ ¡„=Y!Š4Éÿ W¹®Ïieª¥Ù‚²Åû`M¦m)kk±¹±åI¹ Ÿ~U4Õ!¯N‚ í SÓ©+µ\ÔÕÓÔPQ×RÔÒÉE“ ¬%èkğóDÉ%>J‘H)ÖÄ2Y£p²Dêê­íL)·¦‹HÀÒƒÓ¬°mîä˜úlŒõ½”©¤ÅíİÕ“‘f®Áæ+*bÄbö6ùœ*%–Y†#,ö²6ZyJÕ2-½½Ê‰#^’	¤©@}?ËşÇO‚ZiµQÒÔÕÈâ5†5U@cT/µ8bd>A¦à^ÍÀ Ù¯¤”·«Ôg¨³árS8wJŸL’2ùşîIiüÆ:gš:6
Tº‹²TÈÊÊC)EÛ#q-_ä:NóTñé¦§nVDeDyç£•8ÖGzY<RÈâB%¢1¹f]{«kÈT=½¦ñz"
>?Ÿùºy~NO¥z‡.İò1ƒCÍ­$–´ßt_ÇÍ#tÚÁîß[{fVÖ¯ù?ÁÓË+pz“nUGQçñ¸™l±ÊÁ•\~~ àÿ ÄûJ–'òé³#­k×[Ÿ`¦âÇı¼•¯‡ÈÓIeu<jÓâë©Ñ†?/C¶I¼.ÀTÀN™à/[R°Uàˆ4I‘æ<Ç•GùºM4O!ÕÅåè~]øí•–¬¨›™1¹|I-MÅ©d¦©ÃÜ:ª›K=w†s‘±u%<ÁeŒ†Swk2~¤CR6pxWüınåÑ¦âŠÃ?Ãöu2¾I£Š‹íÔT*(¨ŠÃàiDB_4œhO$rÈ€’üˆ® ‘-nê;èmOOımš¯bko²ƒ§èv
EM˜KLğŠ˜L²ÏRõ+<+$RJí¡Ç¨ğˆ‘Uƒº•;TPã[ŸF$üóÖ’òéëáª¨ùş¯óõ2ŸWB¦(qÑHÅÕIâj4+N&#¸,tñq©ÇĞı|ËXàAÌòõèáñ$Õ;ûMzË_‰¬a$Ö‘UµGã’Ş8Äié“¥U¨Àí>«‰ê¹o´ô©B¢ÓLØÙ4ÀÒºSÌÉ¯Ë" xÂ£ÓÉŠ²>¶ÒGîÁã‰¸Wümœ®4êPÅVWNÙ:8éàÏ»ÓËYC[T”ø}åICOQ,Ùj²
Råoã9{â4‚·È­äS[kˆ.G…"÷‡ı‘É¨ÏÓı^œñµü543ÒÖC‹¯Æd!’»’¥òV`ó’ĞT(¨„ƒr’FÂXÙâd©’ÔD*£T‘äiÖF¯©–1Ğøè\k/U §‰"DIädYìúÀ`ãFõjV*YKzTgOL4ÀàuX«$„»ÈR¬"€iTø]$UyuÍ=Úß[:Í´!”1aå1¨j'†ŸÙÖêcNš*„Ó]§§ú‚3;,
RÆ¤›CÆ€+G#RÜ°Ó1JìéRƒHÿ göôİ4ÌîÌÉ+ê}RÄÄÊÅI’×$±ÔÄórI½ı¢r	Çùú¸rM	§Oäcğfâ™PM< ş–lx[“ôÿ \[Ûİ´8é–A §¯A&S.İ¢l}D2m©^JªÆ‚G–M¥®I+ª«i¢[ß,’3¸ÒZ‰ÅšôÄ4kã•/´]²/¡¥~Î˜FšÍ†±ª6õê¡ÿ 'RdÅRÇİVYİÌ™¡İãMB*héËDF­c^5:Xİ–è;—“Ã ´št¯Ç³'SšM=9Pcã•üÓ¸ŸöİĞ=T¦!ˆÌu)8×(!ÕıMpPèeöòEŸáÙôkåû(:«]Óñ*ı W§dzj9ÚH!L®-(|ÚY%RdªW©	`A%|œ5îÔ—)nG'ø›¸õæ[‰¿µjc€Àıƒ§8³RÏˆÓÁGûŠ©8UQKªÅ˜ØjkstÒ^İÎu4„N tçÓDŠ4äù×¬ôÒ¤“zÒ¦y¼‘ÉäóE#hU*Ñén=$›­ì/qı}ÕhSg§	*µêr@•qO¬£Yi^§ø”‚
™)kqÕñ</M˜ÃV%ä¥©´±z^ì“,‘±_k`½DÁ^ÓÇ¤®ÎÕ§şªtóÿ ƒ0ÑÕÓäj Çâw\1ÃEO˜­©®š:là…o7/&”A?kZä=++7ÛƒU¶‚aâD?>“ wqéäÍ%+H()äi5N®bhá’#*ù\éuk(ãQQÈmcd%x|úÓL«Ô/dòÈi ÒÒÇµT”òH¦¡X¦0IT$ ±t`¤lXê3N™/P ê4Ô5r~ÄÑ½DFIŠš’ÇRNNZ4"L.TêK)´Š€Á0˜Ô QÓÊ4šœÿ ƒ¬APÖ&#fyfYÊæY”ÄƒH%ım§‚ÇQûK ÖjM>ñiÓ†2Š®Ñ¤YÚå%_K•ú?«úÿ [ÛJ

®øz­Cv±¯IıÏ±§«œf°sÒÒæ!Š'¢ÉK%6?+KLòÉ3,Ñ‚égµtjÍNÄ£‰ bª¶+Ø$aÔîÅxé_óôÒXØ½¾HÉá§ùºMcv¬µ±ÕÉ‘YikèÈĞd|TÓã*|B Sd©£`ì:ËÊ^'R$…İEÃwV×q5 ,<ˆ?áéÿ ®·•T…>bŸàêd>¥Ëª‰"£§I&s¦œá5«¸¹VmJÎŠÇÈ¥)d-HìæE×q!Qæ©éÃ{j¢Fú‘ÙÒ¬lÏµ6JUó,°‰#D–¥V4ÜG%FEÛS]QAôXRK’hÅQ†•£“_Øz©¹»•t’£ÛN¨h+¢4ğÇA,I½S)û*@cD_&¡§–`Ü›‹_Ú7¾»uÆ|%şˆ§[ŠòÒdüÏNíš—ğ´ë,Ğ«±¤ (6(t{è°7<ôú{eå5s_Ï§Æ;®Ô©¥4ó¤^?Oš†Œ‰5›5<Èú¢š	,/ÊUÊJ@ö¢)’#‡§û=7#×¶˜éêƒ¯‰R£DÕÔp,q³VQ6G?ˆEQ-VÅª¬pj#‰$ÁTÉ¬ª±”ØÀÆĞ;ÁM4oOó›¤Ò+wœzúÿ ³óéIG‚ÂTÑÒå¨gJªm5öôF%M4Ò¥U)†@³ÃSM-<ÏG,K,n¥\!}¹%·ƒÜ¼:¡SÖzí¿4±´¦
x8ôÇ=eQ‚G/TÔ·DĞÓ<Oâ´gÄ™‡6p»hØ‹òé¿§&ª6ƒLÓ2Ã,°,ŠÚ|Æšy_,d,ÒÙ(·˜Ø†*B”
]-Ü@Ñ1¯=<øŸ>¡Ç´aD: åãä¤©‘’ß¤‹–(TJÅ¯©É’úÉ>ÒÍ)jW!şÇú¼úRJğë-×Š*„˜#°T²U Œ(Ö50ú›ùÿ aí !\1Ç¡ëÌäòté˜ëÌVâ Ÿ&~Ñ–zjŠ:ÊIš•éê)¦hji«£ ©]6ŠF†å$Y#fBeò"é’‡íÿ V?ÁÒ)¢gCCä|¿?õW ¾.½ÈQÕÑâ³³Ã-0š‹› Xé©³5~6KR²³-NÚŒ”Â@“i^@æ4XĞˆEÅ™Ô ı¿áãÓqÜÉx7€)ò4­GO'­è©¥1Ñ˜¨~İüR\ÆŠ$oL¦èŠfîÎSåWS)zYÜÊõ ù”-Õ‚úRƒ¥Î¯ñ”qùj©ê"û‰¥¢®o¸4ÉV`š™-N·¼bA(ojÄVh§YyiZ’§Ôğş]T^\3é…È
ÿ ƒ¡#R0q¨‡TãG…&‹ÇJ'€º¬M¤°M6b¦Í¬b×Nû¤¶ìcµb Tı½6¶æWrÅ³ëÒ…²ÏX ë1k…X#%Uõ ¾•
£Ğ>Š¢Ş‘í	¹¸”ş´…¾Óëòé^ˆã4‡Y–h'¥©Í‰„“#Ãx¬ºÕá³%À6Aõ±úY	û?Õùõv$.z˜*)ò•Sä¦,NcÑæ<-_Í¼?xi·¾ÖS,I[¦B# e’u!öeám/eÊı‡üÿ çé‘Ê{£ãæ:z‹9Y_“¤8,ÇÚÖµ5/ÜÑ×âò´uª“eöæ\xáÉÒ*¼/1OÔâ@* Œ©ÄÛF\XÕëÕuzšÿ Ÿ©’n‘<OIGKE2¬aİ‰L—j‰4D¤™®ºdÔJÈYÆ’ĞÔEi§óÿ 7M³¨8é¡ò0¨ijã‚Xš¢8åÇ0¬ufxµSË5B*5­`c~€¤Œ­¤UäX¼ƒP:~]TjvÒ1Ò;9¢»Ë÷TñÍPaXõÉ#ÕLâ(İJÕŒëW¿Œ.¿N«²¡Ã¸"G“óédtN´ç¢å¼1~)d˜+gÔ_ ›ÔYå,.À±å‰$“õ?ÔšáAlgùô¹d¨Ó\ôƒ&b–Tı¢šHbxÿ Ç<‚>¢ßOmÅpñWËËÓª:¤ƒKyã ë-„|d“Um™ã¨¥I^\’
zˆ$§î§}¾e*±ÌìÒ;ĞÊD2ahœe‘İAvŞ!\ğ5¦}¡şG¤ág·}H5¨ã\Ÿõ|üºÅ‹[çÌsII1ªaŠXÈÔÏJt¼!Ô	"p. ±)®aºVÑCSçSN”øÖÒw9ü´Šı»'#DÑ5c=J$ŞŠjÖ£…ä2xPKéi	s FDz ‡!"˜" ŞÊÔôRkòáOõSªÉsÿ ¸‘/Ú@ÿ /CÄH‰ã‹CÊb†UœÕ,«PÄTK'šÌ¥›_
Q²’¢kˆ-6Ğê#ÍÍ[ödñé3›»šxÎiè0?•:uMË-@’›ì)¨©ÂG%ĞÒx™št`I`${Dsb,[Ùtû•õÃw¹P?Àÿ ?J`¶…#Ô2ß>¹ŠÈÄ†ILõL"h¦û˜µ“Ş6$ßĞÚŠ€µPöÈÈÔOç^ŸZ}wU<³PVãá©¢®©ÅK5T”RAXÁ|y
ªfYh«•Ò>âEˆĞ6¤ºn*)Z0|ÿ ÍùtÄšœ/1Ó¬5gO$Ìµ{“íT&«¥¤]ß„ŠJq*._F¿îR›Ë‘&C©®úªÚ¢ºıHFÁşCö“"µ$ÀòÏõ|úw£x²pä!JÜ|ÔAR*`Âc-,Ô!ÌÑIèĞÅWÖB2«jÅL-¤R‡Ïòÿ U:Ñ4½5Öeæy‚H´É,µ‘ËNj<•R¼r4©ILÀDä*$œ0"Ş¡Ğë4£¶ºúãªW¶½3Wd]D±3¶NªE9*Zªhi¼tò.’Ş‰"*C"ãW´R^ÑÌqÆ0O·:Sxq?ìôÓ&A4*ƒ*¢9‘$3F	Ï4â!Å¤‘Œ’ ïv`O>ËæurY³ù–+zƒ¬¸¬ßØ3•Q¡Ùe‘¥±†vÕuÔ†GôâÜí…`„•íêI+S^˜·^ßÅçä-Èÿ w÷PEÔ¬Bz
ø)Ş9)±¹*KÆ•tÃÆÀB]&‹Q0J—(Ë?zF äVŸeiş_³§HÒ]~-±£WàÍşƒ:jk2bƒ>‘Óä*d›ìb¥«Ip™QDÆxª±YIMXŠ¤O6š˜y2D >¸¶’HÅÅ³cl-‘û?ËŸŠæ2w Fãoú¿–=:1ÈÑÓÑO®™˜»6>bxäuIäÓ’_2•%ÛèCdt0Y^5L®cN$j5ÿ /ú¾}*{|KH£?©éOOCA"ÔÁ:TÙi©‡–\šK=,ì%Yª'	*„°@“ gR¥U‘·D¾*#JjGê¦¿*Ÿóu¯ª¾™JGH×ú ûGNqnIqâ¥ÇC$ªPÊ…+S¼+I$…Â(‚ [‚ZÀ¹º	÷›ò¾#ÀZÓ´pÏ¯[†Ò=Z§$×ççóë™¯Z.Ï$‘C*L”Æxã†5úÆŞ°}Lƒ0 saí
É$®<vÔ~Ş'¥ê¡Ô˜ëô,tq:}¯•	’]t•	¤ÑÌ¢ëP†àËèÈÚU¬t¯µ‘İ},˜§p>Ş½&®½dÆGWŠ|m3O£näêÜmj†fIb\UD²á%û”‘ƒC2¼TÈ‰"[Şí÷d$é¥Ïì?g§ø>Î="’9Uê2§‰ó?·ü?·¥6åÁË(Šhêqœ{G]W‚Í%-|u1 e
â–›Ê²EmµHèTH ËŞØDºâÅ<õ.›z×óëŒûš|œ¨#¦ŒE´+“«ªZH#‘ã%ñ×N£È „³,+30`Ê pŞÛ$€3>“éşÏåÃ¦İˆ>¿êÿ Wóé†|ƒÏ…xª#«†WªŠšJšz)8aF5A’¤İ’dp¯¤óµÙ‘İ^Ål”Ç>´ÿ ‹?àáÓ¶Ñ³Y ÿ Wùºlş!OiA\™)ä‚†æ³44²²–.ïÊ—7,¸»iT3b£…ÍÑ¢€«óı½bÇåÒ­eA,ŒBÂî¡KÅ¤Ø¤š8*µ^8ö\f*úéò¨Éÿ Wú¼ºó€ë¥¸u›?ÛûºıÉ)¤’Q.;+‹‘©ë1Õ/QôÀ¼,cµ™X¬¨ê-ìŞÛBRB|ÿ ÕQş‹g²©ÕÕûz28œ®2u¤ÌÕÇ“ÂQS„şñbqÈaG4Òx)c×ö-"h&²™Ø³šv´~Õüeì+Å5Pı£íò¡§MÇ<Ğ —Š(x0¯Ûş_>ª0ôÔ,‰C-<oSöşé¦3OQÒ)˜š_.µ@âRÑêà{\½-/Úr˜ü‰bkåöô¦+²1­€ù"?aqXÿ ^xÕ(¢­yf­zÉˆš9b‰E)0‹•üÍ+"iÖ‹åº$3ÌàV•%<ÒŸ<õ_Ş7é·D@O’ŠÓí§òôûG™8¨\
*zû	:ÏN^HÌ#Cğ¢ûz…®xr¾Ù›vÚ©cÄ§Q_ö:em™Ü5ÃëS^?oNœ›$¬g2A$èTN‰çœ\h’VÒ4‘Í¿©$‚I$¬Ïq9Õ;–¯š~TèÅcŠ?ìÀ§ú½z›dr#ÁO‰RF9R¤/Š¶u”ÓA¢H
2´d:8GĞ•‘È"¤”®x×ŸPZ­Rc–šª¦VC!ÃQ-eÔã«&…R6áÛLğÃR¶$«†JzŸLÎˆœ{¥¬·iâÊ£ş(ÓÏ¤2Å-+Oó”ç?‹£ñPæà\Y«hqøŒ•Ñä6ŞFf!±‹I“ªXš*–`ğš¤tó	Jùõ+1´V°I»„ğôÿ WÛöt›¼|\Gş¯òtáY¹Ë*ã©©Ey	ñÆâhá&ŸÎ¤ÉeéÅå@¢@Ìt–#Zµ!:iOÕşÇL»Ö¿>šäÈ½D²	+£¦`ü˜éV¾µ`ª•%9ª&Q{	¼Q8Fai…™^ÕEpæO—M×4ÿ M’dçJŠ˜U§+O/Şy&’©¥ˆOâš©İ PÈ<%MÒ2F¨Ãû/0Ğ #Ëüü~Î—"xb‰Àzç¨ÓVÆÃÔ
ñ†äGC'ê´Kú	½Ï×W&äi!jÒµêÚ
ğéCK¸#¨¥û:ÈRXfV¦eªĞÃ¡£aÒÃ+0 ß† ñíØ®d„ê£Ê$–5u*Ù/ÛĞsÚŸÂã¬Ÿhd)~ÚE‘NÜÎÏ,4Ôñ_Ìàë%ÕöÃY˜¤Há‘§¯Ú¥Üm¦:%:ãP4ÏÏĞ~ÑëN’o-Ímé"ÿ dÓåşªôŠ9jEHd–,/ÚËUWE4ÔÈ^ô¡)uXF®@Ybpccõöİİ­â Ì1#ü=(Iìœƒ-Fœıœ:o‚‡)4íUQ,µ@$p~òjzyV5Y§œ8VwÒ²0äböVÒ@ìP0OúCOE'üœzy¯mÕ«gı¥GJ‹ÉãÚLUbc$4é))e)ãŠ·_’MEŒlQùò!tğëMolÛESJ‚ÿ ı¿Ë?ì'v¹ºşÕ±è0?gN+‘Íİ©’–:Jh¼b#ø´Î—@ÒÂ»ºnı÷ eòî—&®åE8ÛÓÑÁ
®,:ìÃ‘õË#O;M$w•§S!™/2rTAN/ş¤Øû¬D1¡ãş¯õŸQAŒtË’éáf«£G¤b&€I4”ÓÒKo]Eu;¥%ØP8W:ƒ©÷]àŒi+Qóóû=:£ƒ#ùÿ ±Öj
‡¥R)õe˜Ì‘Kã§…ÔI$°ñÓdcË:àªĞX©e¹2…¬§jF(ŞŸêÿ `ô“C©îáN=-ñ»…=MF¥5øªà*ĞÔĞÖDjéjéäQ8p\«TªEÔxš£ëLÉšõ
¦«;S jˆb¢‰qTÒ¬ŒÓ1xä†‚&Wf$i°n&µ<KjéšĞã¤îF’¸3kÈ¤O÷	üAOp`kRÃ¢°Úâ6kA †e¹(ú àkÇ×§’šuqé1-fÊ|‡IU4ª¤•¸xÖ1q¤\‘ÙÎ‘kûG.–Ëdı½*7N8*É5ˆ!S$,ÌìJ‡‰ìL‹ø&ä?ÆşÓ‰mTÇÙ×—Mz{Îõæ/)
fi«[	™‘’Gª…EE[B¥àL9"9 f"ò},Áe_IUGqU¢Ü-~|?ŸùúB`p>£ zL4Pd,ğ‚(V®4§­¡Ÿ^æ˜2A,õséxd
t´Ue[ñ’¨í“êÆµ}kü:»‡Èóñéå™şÔOAéôl´r”tÓ¨Ğ@0ÑHŞH"@Ó³4qúPŒªX¦§QbÛÛİ;w1E®A&¿åé@ºÛã^ÕßéE+Ò¾-±C<°øiŞ2¾ZFtS4B@@‰GŠE.c –A(%‡µT±Z­#/U*>u?ìu¦½»xkESü8óù¦ÆsxØcŠšœK;IKS8-+¨`4ÿ rÍ%Â«ŠÛAôhn·Kâ1~˜şqòéÈ-¢Õª\ƒş¯Ï§Ê(*äxä–yX$á¥ôFxzÁ%ù:Ø)$’H¹>ËüFv¬‡WÚoû=-ªÆÔŒPt³¡ª´cÁ2Çt¨†ªHjáª£‹
zåkÇP–‘DÑº—³,—GrmHa“şË­KSB;«ÔÌ\´ÑK®’J|jÓLœ^Aêr%UO¸>ĞÉ]Œ+($‹îb ´f•«*èï¶ùÎ›”Ò}Gùytá›Šgü?ìÓ¥àªM$¸úŠjåBõ8÷¬ÇÕ"G%Ù+hg£fŠ²„'Š¥-bJÍ2+"¯!b¡†ŒËÏÏ=4j[çÖzìş*¶£Æ’Ë‘­§R°Qâé~êLs!×#9qMN$¿í‰ä4Ówu÷fˆ‘ªs «ötâêÑÛÒW-\‹gHgPôØ9¢­­u„†\¤ÿ äê¬ä¬¢–ïm+R-§Ùl³mQ¶ª™~Ïzº­Ãe…•xşÏóşÎš’ª7ÚMIY‘$’zú€c$•5ó1²YVpÔ†ítï}­@hÓéŠş|OK!E ê?ÕõW¬)–Z:¥¨òÔ5µA¡Š¥ÜeT%%½€*¿Ãóì­î$WÕ¨ã9'óûzq£…(?`ênT`w\ËR’QÔA¦¦-•©rTS\d:Æ«²Ê€•pH`oÉ¦ğÈ4áş¯<Ñ}Å™sØÄSùşß³ 1ˆİ8”¥hêrQSŠˆâÎĞºÉœ¦¦w†¸óyË²Ñi,,e¤E‘W-ÊŞ¶’•“ÈÇäqş¬tÂ¼ĞCø€áö?õg®t0TIC~37‘¨¦ Àjê2õf8İ]¥ŸYb‘8@Íu á€ ûCq>ê’õÊNx±#ü4=)‰6§:¤ÑN4?ê¯N¸†¬­I¥¯Èfëc§Á4ÔeŒéxŒÕ"O¸2Èbb“‘}!Õ‚¸ât‡ıØ\ºšŒù~ÃÕİ¤GüFİekÒª†¢›U0jhj©ÄÓÁO÷*•R]ãJzÆË5ˆvq$Å\z˜!}ÖKÛm¸£†¤~#ŸÏ9ÏIØ\İ>©\Ğù_*œ"İs¨ÒB1®cO‰PFî*5Óı/9U,¤zµenW—,L¯  ÿ ?Kb¶…P5}¹¡êuB*Qik‘Èñ	!bãÒ?ye…Ä¢R Sêõ(±\{~ŞiêÂƒÔù~}=¡	à>Ê»‰àÇQÔáj'x™êñéKöuryÉJ¬_3™#Sı¼„¨o"‘r`—ö’bdÇ¨Áÿ 1é¿Ä‚Ÿ/özV¦R†’™eÊÓèf’£/‡9$¤)*d!”}î5£"äÕDa
 ®{XC¬‚¶¯Qüÿ ?N“ÒP?PAÿ WË§ÇÜtX¸ìôÕÔK­aª¦’èe¾³”’ÈäEÂFÖ¿ ]¼D> WÌğûz£tÍ&f¦£ÁT±=<®¦
œ„¯™åˆ J|UÖzpè¨wu.|>`úÂWH’öcüİ5Rq^™²5BrÂ¬eH¢Z©Jš8Qµ*Ë)PA®0òÇ‘e ÷f‚YncG1,`S99ş\kùS¥1ÓÔrOú¿ÙêõÂx‚‰j<j)ä>HÒªh»4¥BzSèª-`‚s#åÙ›óÿ U:Rd§  û:q£Üï	¤¯†*èÌL„U(•$UÒ4Ç‡¶”ô½ø ~=Ö;©!j©üqöôÃ¢2šâ¾#r;Nh4Íµs¦(%‚¢3·3uS¶8G#ñãk!$ úBLl_ÚÁ¹Âãõ‰Júòzª$ğ.!: Ó ôoòõ}½!è¡¯ZA–›+ƒ®x¾Î‡•ÒÒÑéãX¼TUøÙ¼5¢¤mTUV²5ø‡Å‚WhÏü¨:qM¬¦“"Æã¡ş^gş/]%$Ù\¬õ†’–ªªj–JÇ$I€³’t@µ‚o«Úk_ŞS°f‘Æ½ŞœNkÒ¶;Eº¬óéEöÑÇ™	«‚¥[ıÈÖC—¯2¥:¼‰Ñd]|h ıâcğªÈ‰qíY[˜Êå®$KHóÉ4ùôÓ^\J<8€…  ¯ùzv“rÑÀ‘ÒœKI<,ÕÆI&­™İÖ9mSTC8<®€Á@:t"Å·›Íãşœ@DæéËkd³SêÕ¹¶Eëeiê*ê&§1O!•šœ5‘Y‹5î	mM«“í
M#5KÛşÏF
ˆ¸
ä:ç5TrES%$Õ¯.RIŞXª±m‹,Rã«">X}C×
Iã$cúÜÅ/DCDİÿ nh?™RD¢?gìùtáŠœL­üRu:(2µTt•P.Ôôù6x±õx£¬ûG*™™µpË¶NÕ½ÛÃü"a20Ò*=Gù¿ÍÒ›œÄEXc§šX2¢ZÌ^B†lv]‘×ÉôôÕ>2`²•‘•Z7nCZÄ¯ğ5Ô½Ã­U†kÓlÙö®¨ª¥ÇQÔUË2ÍqÒÑ£Ëd4õY'h ¤Y@dÔ¥4øËÉ; ‰ò¦GÚÕötÆ¢¨uóKL#’¸VSJñ£ÒPI5­7‡î?ˆ"¬óy“…§U^ŒÄïºjğêI<=~Ş4ş}9sQ_ğ“¦xêâ§F§†ÇÅ$"ĞĞÇTÔ¬’jO|!?êçpÒòüÛÚ	§iTé%G 4<ÙÒÔz-h:ËGœşÎ$bğ¹y=HŒÊºÄtä›"†(y
½­í"Êñ1e$}¦½Q•_ˆoQ³LFuª+qµõ[_)"uXÉ£«(Ë"İ&³:ëĞÎ¡Æ¢A„{¡I…~b ôKfg×ÏÌT«ìè9Éã·>¥š¼ñÕf9ë3[^¦zˆê^0ºÊpâª€EUbfB¾“0ÒSİÖinI5x•ÕFüsöç¦üOÁw
ü@T~Ï/åÓ‰‹ ”]C™¯û)ÖyÅwñz‚Rƒ©ªç˜‹­î¨\€\[õ{@òî)Œ´™ş"Oì¯—K"i\ÚĞåÓÆ&˜WÅ@õ’WÖÉ0‘£)[2QH*4M:RQ53€´ôÏ3FğÆë¼¥¡UC‚ûÊwsä¤’ÈR´ôé·½P
ÚBˆ* ¯§ŸùºPReéñ´òGSCGÀÓªš1ıË½-$q¬1“äõHP°ÿ 7®ÁIbãukTğlâ¤R§9ùùşŞ¨K,šæfoÏüd9ÆÈÆ¾¹i#w2ÍLJ¿’hç.R’ÒFXyöJnî' ÈÄšää.ŒÖ8j@Ï©RÖÓ