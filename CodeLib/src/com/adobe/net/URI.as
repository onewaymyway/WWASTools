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
		 * <p>Never pass a full URI to this function.  A URI can only be prop.           x}lCC �lC(5    ..          x}lCC �lC�4    �Q�V�N8�b s-Nof. p n g     ��������~1PNG  Y]lCC  ehC�4��" A�Q�V�N8�b s-Nof. p n g     ��������~1PNG  Y]lC+C �TCꈙ�&                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 f=8֦9nXk]o� 	�g��H�#���� ܓcI�=:tJUq�Q���Eg��V�Xk$��s�#�?␀�#����4�K6φ���j���cOe��#�z9��i".�A��{v�%������)�G�wֹmsmi�Q�	��yG�1&wiG,8���j��5x48܊S^�$LO�I�y`[�aP� _�I�oa����+��������FO�U�q,�S	���,��R7�"YT:��=�{����տ��Ž����A�gJ*N��4�Ի���`��i���i�ii`UDY�]Τ��K*���*��5��:��J��Ƌ�?��Ɵi5wLtJ��(LF:dV�HU�L�UTj>�gG�>ѵ��)��G��fwj/ʝ?� v�*#O�J]
��G�6d,��UHU�r�p ����v:ޠ�p�:sJ# ��^�g��R��BSLe�;g�%��Y[z� ���M�Fu6?��g����Ԛ~�\�.=�Wo�KQW_��E��m��tҚ��u#ψ���.Z����,���5fv�P�x2�'�ޚ��=��������K���b�p`��_å�������{
�U}5$�X����5#Zx&@��#�)����h	5�Sa��P7���ITϢ��厠�?�;�2����[x�����[H�ƝW�`t��j�ah#�Xde�?����G9R�R�<��ck7�D����KqCw�����n=Z2����D�G�$���7�y�p��	i�u����%<R'�.�PDr�M��BW���;x�]�����������I�iO��E��F�RIl��.�?�� W�z����GE�0XU� ?p�|�I]�A�<���}��k���I6NOAN�����{�:Vb�ϻ`,��Q�±Ro�x�����i�H��MX]QIs�y#��)�sZң���4�ZH�2���?��G�¬MQ<sT���<2G.���蘣5�jܐ�r�Ѽ7e�`}I�K��
�
z�Rq�g$��ȍ�h^�h��(�,�h� �uQ"�Ѹ+�3^;t��w1>�SOZ��oҴ��~�?��ݶ,T�
r�2ǭ�;�u�ؐDӳ��4a� HQ���f�
xQx��X��+���R�H�\!��jɖX�50oڍԻM,s����k���U�pn/t�^�� ��=Y!�4�� W��Ϟie��������`M�m)kk����I� �~U4�!�N� � Sө+�\����PQ�R���E���%�k��D�%>J�H)��2Y�p�D���L)���H�҃Ӭ�m���l���������Փ�f���+*b�b�6���*%�Y�#,���6ZyJ�2-��ʉ#^�	��@}?���O��Zi�Q�����5��5U@cT/�8bd>A��^�� ٯ�����g���rS8wJ�L�2���Ii��:g�:6
T���T���C)E�#q-_�:N�T�馧nVDeDy磕8�GzY<R��B%�1�f]{�k�T=���z"
>?���y~NO�z�.ݞ�1�Cͭ$���t_��#t����[{fV���?���+pz�nUGQ��l����\~~ �� ��J�'���#�k�[�`����������Ieu<j���ц?/C�I�.�T�N��/[R�U��4I��<ǕG��M4O!����~]�핖�����1�|I-Mũd��Í�:��K=w�s��u%<�e��Swk2~�CR6pxW��n�Ѧ��?��u2��I�����T*(�����iDB_4�hO$rȀ���� �-n�;�mOO�m��bko����v
EM�KL���L��R�+<+$RJ�Ǩ���U���;TP�[�F$��֒���᪨�����2�WB�(q�H�՞I�j4+N&�#�,t�q��А�|�X�A������$�;�Mz�_��a$֑U�Gげ�8�i���U����>����o���B���L��4�ҺS�ɯ�" �x£�����>��G���㉸W�m��4�P�VWN�:8��ϻ��YC[T��}�ICOQ,�j�
R�o�9{�4��ȭ�S[k�.G�"�����ɨ�����^�����543��C���d!������V`���T(���r�F�X��d����D*�T��i�F���1���\k/U ��"DI�dY���`��F�jV*YKz�TgOL4��uX�$���R�"�iT�]$Uyu�=��[:ʹ�!�1a�1�j'���֐�cN�*��]����3;,
RƤ�Cƀ+G#Rܰ�1J��R�H� g���4����+�}R���ŁI��$����rI���r	����rM	�O��c�f�PM< ���lx[��� \[ېݴ8�A ��A&S.ݞ�l}D2m�^J�ƂG�M��I+��i�[�,�3��Z�Ś��4k�/��]�/��~ΘF�͆��6��� 'Rd�R��VY�̙���MB*h��DF�c^5:Xݖ�;��� ���t�ǳ'S��M=9Pc��Ӹ����=T�!��u)8�(!��MpP�e��E��ُ�k��(:�]��*��W�dzj9�H!L�-(|�Y%Rd�W�	`A%|�5�ԗ)nG�'�����[���jc�����8�R����G���8UQK�ō��jkst�^��u4�N t��D�4��׬�Ҥ�zҦy�����E#hU*��n=$���/q�}�hSg�	*��r@�qO���Yi^����
�)kq��</M��V%䥩��z^�,��_k`�D�^�Ǥ��է��t�� ���0����j ��w\1�EO�����:l��o7/&��A?kZ�=++7ۃU��a�D?>� wq���%+H()�i5N�bh�#*�\�uk�(�QQ�mcd%x|��L��/d��i������T��H��X�0IT$ �t`�lX�3N�/P �4�5r~�ѽDFI����RN�N�Z4"L.T�K)����0��� Q��4��� ��AP�&#fyfY��Y�ăH%�m���Q�K �jM>��iӆ2���ѤY��%_K��?��� [�J

��z�Cv��I�ϱ���f�s���!�'��K%6?+KL��3,т�g�tj�Nģ� b��+�$a���x�_���Xؽ�H����Mcv����ɑYik���d|T��*|B�Sd��`�:��^'R$��E�wV�q5 ,<�?��� ���T�>b���d>�˪�"��I&s���5���VmJΊ�ȥ)d-H��E�q!Q����{j��F����Ҭlϵ6JU�,��#D��V�4�G%F�E�S]QA�XRK�h�Q����_�z����t����N��h+�4��A,I�S)��*@cD_&���`ܛ�_�7��u�|%���[���d��N횗��,Ы���(6(t{�7<���{e�5s_ϧƞ;�ԩ�4�^?O����5�5<����	,/�UʍJ@��)�#���=7#׶��ꃯ��R�D��p,q�VQ6G?�EQ-VŪ�pj#�$�Tɬ�������;�M4oO�����+w�z�� ���IG��T���gJ�m5��F�%M4ҥU)�@��SM-<��G,K,n�\!}�%��ܼ:�S�z�4���
x8��=eQ�G/TԷD��<O�g���6p�h؏����&�6�L�2�,�,��|ƚ�y_,d,�ِ(��؆*B�
]-�@�1�=<��>�ǴaD: ��䤩��ߤ��(TJů�ɒ��>��)jW!�����RJ��-׊*��#�T�U �(�50���� a� !\1ǡ����t���V⠎�&~іzj�:�I����)��hji�� �]6�F��$Y#fBe�"钇�� V?��)�gCC�|�?�W��.��Q��ⳳ�-0�����X驳5~6KR��-Nڌ��@�i^@�4X��Eř� ������q��x7�)�4�GO'�詥1ј�~��R\Ɗ$oL��f��S�WS)zY�������-Ղ��R�����q�j��"������o�4�V`��-N���bA(oj�Vh�YyiZ�����]T^\3��
� ��#R0q��T�G�&��J'���M��M6b�ͬb�N����c��b�T��6��Wrų�҅��X��1k�X#%U� ��
��>��ޑ�	�����������^��4��Y�h'���͞���#�x����%�6A����Y	�?���v$.z�*)�S䞦,Nc��<-_�ͼ?xi�����S,I[�B# e�u�!�e�m/e����� ����{���:z�9�Y_��8,��ֵ5/������u��e��\x���*�/1O��@* ����F\X���uz�� ���n�<OIGKE2�a���L�j�4D����d�JȁYƒ��Ei��� 7M��8��0�ij�X��8��0�ufx�S�5B*5�`c�~�����U�X���P:~]Tjv�1�;9����T��PaX��#�L�(�JՌ�W��.�N���ø"�G���dtN���1~)d�+�g�_ ��Y�,.���$��?Ԛ�Alg���d��\�&b�T���Hbx� �<�>��Om�p�W��Ӫ:��Ky��-�|d�Um�㨥�I^\�
z�$���}�e*����;��D2�ah�e��Av�!\�5�}��G��g�}H5��\��|��ŋ[��sII1�a�X���Jt�!�	"p. �)�a�V�CS�SN����w9������'#D�5c=J$��j֣��2xPK�i	s�FDz �!"�"�����Rk��O�S��s� ��/�@� /C���H��C�b�U��,�P�TK'����_
Q���k�-6��#��[�d��3���x�i�0?�:uM�-@���)���G%��x��t`I`${�Dsb,[�t����w�P?�� ?J`��#�2�>���ĆIL�L"h������6$��ڊ��P����O�^�Z}�wU<�PV�ᩢ���K5T�RAX�|y
�fYh���>�E���6���n*)Z�0|� ��tĚ�/1Ӭ5gO$̵{��T&����]߄�Jq*._F��R���&C����������HF��C���"�$����|�w��x�p�!J�|�AR*`�c-,�!��I���W�B2�j�L-�R���� U:�4�5�e�y�H��,���Nj<�R�r4�IL�D�*�$�0"����4�����W��3Wd]D�3�N��E9*Z�hi�t�.�މ"*C"�W�R^��q�0O��:Sxq?���&A4*�*�9�$3F	�4�!Ť��� �v`O>��urY����+z������3�Q��e����v�u���G����`����I+S^��^����-��� w�PEԬBz
�)�9)��*Kƕt���B]&�Q0J�(�?zF ��V�ei�_���H��]~-��W�����:jk2b�>���*d��b��Ip�QD�x��YIMX��O6��y2D�>���H�ųcl�-��?˞���2w�F�o���=:�1�����O����6>bx�uI���_2�%��Cdt0Y^5L�cN$j5� /��}*{|KH�?��OOCA"��:T�i���\�K=,�%Y�'	�*��@� gR�U��D�*#JjG���*��u����JGH�� �GNqnIq���C$�Pʅ+S�+I$��(�� [�Z���	���#�ZӴpϯ[��=Z�$����뙯Z�.�$�C*L��x�5��ް}L�0 sa�
�$�<v�~�'��Ԙ��,tq:}��	��]t�	��̢�P������U�t����},���p>޽&��d�GW�|m3O�n���mj�fIb\UD��%�����C2�Tȉ"[���d$���?g��>�="�9U�2���?��?��6���(�h�q�{G]W��%-|u1 e
▛ʲEm�H�TH ���D���<��.�z�����|��#��E�+���ZH#��%��N�� ��,+30`� p��$�3>�����æ݈>��� W��|���x�#��W���J�z)8a�F5A��ݒdp����ّ�^�l��>�� �?��Ӷѳ�Y�� W��l�!OiA\�)䂆�44����.�ʗ7,��iT3b���Ѣ�����b��Ҏ�eA,�B��KŤؤ�8*�^8�\f*����� W����른u�?�������)���Q.;+����1�/Q���,c��X���-���BRB|� �Q��g�����z28��2u���Ǔ�QS���bq�aG4�x)c��-"h&���س�v�~Ձ�e�+�5P����M�<� ��(x0���_>��0��,�C-<oS���3OQ�)��_.�@�R���{\�-/�r���bk����+��1����"�?aqX� ^x՞(��yf�zɈ�9b�E)0����+"i֋�$�3��V�%<ҟ<�_�7�D@O�������G�8�\
*z�	:�N^H�#C��z��xr�ٛv�کcħ�Q_�:em��5��S^?oN��$�g2A$�TN��\h�V�4�Ϳ�$�I$��q9�;���~T��c�?�����z�dr#�O�RF9R�/��u��A�H
2�d:8GЕ��"���xןPZ�Rc����VC!�Q-e��&��R6��L��R�$��Jz�LΈ�{����i��ʣ�(�Ϥ2�-+O���?���P��\Y�hq�����6�Ff!��I��X�*�`��t�	J��+1�V�I����� W��t��|\G���t�Y��*㩩Ey	���h�&�Τ�e����@�@�t�#Z��!:iO����L�ֿ>��ȽD�	+��`���V��`��%�9�&Q{	�Q8Fai��^�Ep�O�M�4� M�d�J��U�+O/�y&����O⚩ݠPȎ<%M�2F���/�0� #���~Η"xb��z��V���
��GC'��K�	���W&�i!jҵ�ڏ
��CK�#���:�RXfV�e��á�a��+0 ߆ ��خd�ꎣʝ$�5u*�/��s�ڟ�㬟hd)~�E�N���,4��_̐��%���Y��H���ڥ�m�:%:�P4���~��N�o-�m�"� d������9jEHd�,�/��UWE4��^��)uXF�@Ybpcc���ݭ� �1#�=(I윃-F���:o��)4�UQ,�@$p~�jzyV5Y��8VwҲ0�b�V�@�P0O�COE'��zy�mիg��GJ����LUbc$4�))e)㊷_�ME�lQ��!t��Mol�ESJ�� ���?�'v���ձ�0?gN+��ݩ��:Jh�b#��Η@����n�� e���&��E8����
��,:�Ñ��#O;M$w��S!�/2rTAN/�����D1������QA�t˒���f��G�b&�I4���Ko]Eu;�%�P8W:���]��i+Q���=:��#�� ��j
��R)�e��̑K㧅�I$���dc��:���X�e�2���jF(ޟ�� `��C���N=-񻁅=MF��5���*����Dj�j��Q8p\��T��E�x����Lɚ�
��;S j�b���qTҬ��1x䆂&Wf$i��n&�<Kj����F��3kȤO�	�AO�p`kRâ���6k�A �e�(� �k�ק��uq�1-f��|�IU4����x�1q�\��Αk�G.��d��*7N8*�5�!S$,��J����L��&�?��ӉmT��ם�Mz{���/)
fi�[	���G��EE[B��L�9"9 f"�},�e_IUGqU��-~|?���B`��p>��zL4Pd,��(V�4����^�2A,�s�xd
t�Ue[������Ƶ}k�:��ȏ������OA��l�r�tӨ�@0�H�H"@ӳ4q�P���X��Qb���;w1E�A&���@���^���E+Ҿ-��C<��i�2�ZFtS4B@@�G�E.c��A(%��T�Z��#/U*>u?�u����xkES�8����sx�c���K;IKS8-+��`4� r�%«��A��hn�K�1~���q���-�ժ\���ϧ�(*�x�yX$�ၥ�Fxz�%�:�)$�H�>��Fv��W�o�=-��ԌPt����c�2�t���Hj᪣��
z�k�P��DѺ��,�GrmHa��˭KSB;���\��K��J|j�L��^A�r%UO�>��]�+($��b �f���*���Λ��}G�yt�ᛊg�?�ӥ���M$���j�B�8����"G%�+hg�f����'��-bJ�2+"�!b������=4j[��z��*��ƒˑ��R�Q��~�Ls!�#9qMN$���4�wu�f���s���t�����W-\�gHgP��9���u��\�� ��䬢��m+R-��l�mQ���~Ϟz���e��x����Κ����7�MIY��$�z��c$�5�1�YVp�Ԇ�t�}�@h���|OK!E �?Տ�W�)�Z:����5�A�����eT%%��*�����$Wը�9'��zq���(?`�nT`w\�R�Q�A���-���rTS\d:ƫ�ʀ�pH`oɍ���4����<�}řs��S��߳��1��8��h�rQS����кɜ���w���y���i,,e�E��W-���������q��t¼�C�����?�g�t0TIC~37��� �j�2�f8�]��Y�b�8@�u� � �Cq>���Nx�#�4=)�6�:��N4?�N����I���f�c���4�e��x��"O�2�bb��}!Ղ��t���\����~�ՍݤG�F�ekҪ���U0jhj����O�*�R]�Jz��5�vq$�\z�!}�K�m����~#��9�I�\�>�\��_*�"�s��B1�cO�PF�*5��/9U,�z�enW�,L��  � ?Kb��P5}���uB*Qik���	!b���?ye�ĢR S��(�\{~�i���~}=�	�>������Q��j'x����K�ury�J��_3��#S����o"�r`���bdǨ�� 1���Ă�/�zV�R���e���f��/�9$��)*d!�}�5�"��Da
 ��{XC����Q�� ?N��P?PA� W˧��tX�����K�a����e������E�Fֿ ]�D> W���z�t�&f���T�=<��
����� J|U�z�p�wu�.|>`��WH���c��5Rq^��5Br¬eH�Z�J�8Q�*�)PA�0���e �f�YncG1,`S99�\k�S�1���rO������x��j<j)�>H��h�4��BzS�-`�s#�ٛ�� U:Rd�  �:q���	���*��L�U(�$U�4Ǉ����� ~=�;�!j���q��â2�⾝#r;Nh4͵s�(%��3�3uS�8G#��k!$ �BL�l_�������J��z��$�.!:�� �o��}�!衯Z�A��+��x�·������X�TU�ټ5��mTUV�5��łWh���:qM���"�㎡�^�g�/]%$�\�������j��J�$I����t@��o��k_�S�f��ƽޜNkҶ;E�����E����	���[���C��2�:����d�]|h ��c�ȉq�Y[���$KH��4���^\J<8��� ��zv�r���ҜKI<�,��I&����9mSTC8<���@:t�"ŷ�����@D����kd�S�՞��E�ei�*�&�1O!���5�Y�5�	mM���
M#5K���F
��
�:�5TrES%$կ.RI�X��m�,R�">X}C�
I�$�c���/DCD�� nh?�RD��?g��tኜL��Ru:(2�Tt�P.���6x��x���G*����p˶N������"a20�*=G���қ��EXc��X2�Z�^B�lv]������>2`����Z7nCZį�5ԽíU�k�l�������Q�U�2�q�ѣ�d4�Y'h��Y@dԥ4���; ��G���tƢ�u�KL#��VSJ��PI5�7��?�"��y���U^����j��I<=~�4�}9sQ�_���x��F����$�"���TԬ�jO|!?��p�����	�iT�%G�4<���z-h:�G���$b�y=H�ʺ�t�"�(y
���"��1e$}��Q�_�oQ�LFu�+q��[_)"�uX���(�"��&�:��ΡƢA�{�I�~b��Kfg���T���9��>�����f9�3[^�z��^0��p⪝�EUbfB��0�S��inI5x��F��s���O�w
��@T~�/�Ӊ� ��]C���)�y�w�z�R���瘋��\�\[�{@��)����"O쯗K"�i\�����&�W�@��W��0��)[2QH*4M:RQ53����3F������UC���ws䤒�R��鷽P
�B�* �����PRe���GSCG��Ӫ�1�˽-$q�1���HP�� 7��Ib�ukT�l��R�9���ި�K,��fo��d9��ƾ�i#w2�LJ��h�.R��FX�y�Jn�' �Ě��.��8�j@ϩR��