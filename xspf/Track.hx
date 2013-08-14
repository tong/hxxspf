package xspf;

import xspf.Playlist;

using xspf.XMLUtil;

class Track {
	
	/**
	 	URI of resource to be rendered.
	 	Probably an audio resource, but MAY be any type of resource with a well-known duration,
	 	such as video, a SMIL document, or an XSPF document.
	 	The duration of the resource defined in this element defines the duration of rendering.
	 	xspf:track elements MAY contain zero or more location elements,
	 	but a user-agent MUST NOT render more than one of the named resources.
	*/
	public var location : List<String>;
	
	/**
		Canonical ID for this resource.
	 	Likely to be a hash or other location-independent name, such as a MusicBrainz identifier
	 	or isbn URN (if there existed isbn numbers for audio). MUST be a legal URI.
	*/
	public var identifier : String;
	
	/**
		Name of the track that authored the resource which defines the duration of track rendering.
		This value is primarily for fuzzy lookups, though a user-agent may display it.
	*/
	public var title : String;
	
	/**
		Human-readable name of the entity (author, authors, group, company, etc) that authored the
		resource which defines the duration of track rendering.
		This value is primarily for fuzzy lookups, though a user-agent may display it.
	*/
	public var creator : String;
	
	/**
		A human-readable comment on the track in text/plain format.
	*/
	public var annotation: String;
	
	/**
		URI of a place where this resource can be bought or more info can be found.
	*/
	public var info : String;
	
	/**
	 	URI of an image to display for the duration of the track.
	*/
	public var image : String;
	
	/**
		Name of the collection from which the resource which defines the duration of track
		rendering comes. For a song originally published as a part of a CD or LP, this would
	 	be the title of the original release. This value is primarily for fuzzy lookups, though
	  	a user-agent may display it.
	*/
	public var album : String;
	
	/**
	 	Integer with value greater than zero giving the ordinal position of the media on the
	 	xspf:album. This value is primarily for fuzzy lookups, though a user-agent may display it.
	 	xspf:track elements MAY contain exactly one.
	 	It MUST be a valid XML Schema nonNegativeInteger.
	*/
	public var trackNum : String;
	
	/**
	 	The time to render a resource, in milliseconds.
	 	It MUST be a valid XML Schema nonNegativeInteger.
	 	This value is only a hint -- different XSPF generators will generate slightly different
	 	values. A user-agent MUST NOT use this value to determine the rendering duration, since the
	 	data will likely be low quality. xspf:track elements MAY contain exactly one duration element.
	 */
	public var duration : Null<Int>;
	
	/**
	 * The link element allows XSPF to be extended without the use of XML namespaces. 
	 * xspf:track elements MAY contain zero or more link elements.
	 */
	public var link : List<Link>;
	
	/**
	 	The meta element allows metadata fields to be added to xspf:track elements.
	 	xspf:track elements MAY contain zero or more meta elements.
	 */
	public var meta : List<Meta>;
	
	/**
	 	The extension element allows non-XSPF XML to be included in XSPF documents.
	 	The purpose is to allow nested XML, which the meta and link elements do not.
	*/
	public var extension : List<Extension>;
	
	public function new() {
		location = new List();
		link = new List();
		meta = new List();
		extension = new List();
	}
	
	public function toXml() : Xml {
//		var createElement = Playlist.createElement;
		var x = Xml.createElement( "track" );
		if( !location.isEmpty() )
			for( l in location )
				x.addChild( Xml.parse( "<location>"+l+"</location>" )  ); 
		x.attach( this, 'identifier' );
		x.attach( this, 'title' );
		x.attach( this, 'annotation' );
		x.attach( this, 'info' );
		x.attach( this, 'image' );
		x.attach( this, 'album' );
		x.attach( this, 'trackNum' );
		x.attach( this, 'duration' );
		if( !link.isEmpty() ) { 
			for( e in link ) {
				var l = XMLUtil.createElement( "link", e.content );
				l.set( "rel", e.rel );
				x.addChild( l );
			}
		}
		if( !meta.isEmpty() ) { 
			for( e in meta ) {
				var m = XMLUtil.createElement( "meta", e.content );
				m.set( "rel", e.rel );
				x.addChild( m );
			}
		}
		if( !extension.isEmpty() ) { 
			for( e in extension ) {
				var ex = Xml.createElement( "extension" );
				ex.set( "application", e.application );
				ex.addChild( e.content );
				x.addChild( ex );
			}
		}
		return x;
	}
	
	public static function parse( x : Xml ) : Track {
		var t = new Track();
		for( e in x.elements() ) {
			var v = e.firstChild().nodeValue;
			switch( e.nodeName ) {
			case "location" : t.location.add( v );
			case "identifier" : t.identifier = v;
			case "title" : t.title = v;
			case "creator" : t.creator = v;
			case "annotation" : t.annotation = v;
			case "info" : t.info = v;
			case "image" : t.image = v;
			case "album" : t.album = v;
			case "trackNum" : t.trackNum = v;
			case "duration" : t.duration = Std.parseInt(v);
			case "link" : t.link.add( { rel : e.get("rel"), content : v } );
			case "meta" : t.meta.add( { rel : e.get("rel"), content : v } );
			case "extension" : t.extension.add( { application : e.get("application") , content : e.firstElement() } ); 
			}
		}
		return t;
	}
	
}
