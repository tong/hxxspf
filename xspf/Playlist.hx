package xspf;

using xspf.XMLUtil;

/**
	The extension element allows non-XSPF XML to be included in XSPF documents.
	The purpose is to allow nested XML, which the meta and link elements do not.
*/
typedef Extension = {
	var application : String;
	var content : Xml;
}

/**
	The link element allows XSPF to be extended without the use of XML namespaces.
*/
typedef Link = {
	var rel : String;
	var content : String;
}

/**
	The meta element allows metadata fields to be added to xspf:track elements.
	xspf:track elements MAY contain zero or more meta elements.
*/
typedef Meta = {
	var rel : String;
	var content : String;
}

class Playlist {
	
	/** XML namespace */
	public static inline var XMLNS = "http://xspf.org/ns/0/";
	
	/** XSPF playlist version */
	public static inline var VERSION = "1";
	
	/** The max count of attribution elements */
	public static inline var MAX_ATTRIBUTION = 10;
	
	/** Title for the playlist. */
	public var title : String;
	
	/** Name of the entity (author, authors, group, company, etc) that authored the playlist. */
	public var creator : String;
	
	/**
	 	A human-readable comment on the playlist.
	 	This is character data, not HTML, and it may not contain markup. 
	 	xspf:playlist elements MAY contain exactly one.
	 */
	public var annotation : String;
	
	/**
		URI of a web page to find out more about this playlist.
		Likely to be homepage of the author, and would be used to find out more about the
		author and to find more playlists by the author.
	*/
	public var info : String;
	
	/**
		Source URI for this playlist.
		xspf:playlist elements MAY contain exactly one.
	*/
	public var location : String;
	
	/**
		Canonical ID for this playlist.
		Likely to be a hash or other location-independent name.
		MUST be a legal URI.
		xspf:playlist elements MAY contain exactly one
	*/
	public var identifier : String;
	
	/**
		URI of an image to display in the absence of a //playlist/trackList/image element.
	*/
	public var image : String;
	
	/**
		Creation date (not last-modified date) of the playlist, formatted as a <a href=http://www.w3.org/TR/xmlschema-2/#dateTime>XML schema dateTime.</a>
	*/
	public var date : String;
	//public var date(default,setDate) : String; //TODO
	
	/**
		URI of a resource that describes the license under which this playlist was released. 
	*/
	public var license : String;
	
	/**
		An ordered list of URIs.
		The purpose is to satisfy licenses allowing modification but requiring attribution.
		If you modify such a playlist, move its //playlist/location or //playlist/identifier
		element to the top of the items in the //playlist/attribution element.
		xspf:playlist elements MAY contain exactly one xspf:attribution element.
		Such a list can grow without limit, so as a practical matter we suggest deleting ancestors
		more than ten generations back.
	*/
	public var attribution : Xml;
	
	/**
		The link element allows non-XSPF web resources to be included in XSPF documents
		without breaking XSPF validation. 
		xspf:playlist elements MAY contain zero or more link elements.
	*/
	public var link : List<Link>;
	
	/**
		The meta element allows metadata fields to be added to XSPF.
	*/
	public var meta : List<Meta>;
	
	/**
		Ordered list of xspf:track elements to be rendered.
		The sequence is a hint, not a requirement; renderers are advised to play tracks from top
		to bottom unless there is an indication otherwise.
		If an xspf:track element cannot be rendered, a user-agent MUST skip to the next xspf:track
		element and MUST NOT interrupt the sequence.
	*/
	public var tracklist : Tracklist;
	
	public function new() {
		meta = new List();
		link = new List();
	}
	
	public function toXml() : Xml {
//		if( tracklist == null )
//			throw "XSPF playlist elements MUST contain a trackList element";
		var x = Xml.createElement( "playlist" );
		x.set( "version", VERSION );
		x.set( "xmlns", XMLNS );
		x.attach( this, 'creator' );
		x.attach( this, 'annotation' );
		x.attach( this, 'info' );
		x.attach( this, 'location' );
		x.attach( this, 'identifier' );
		x.attach( this, 'image' );
		x.attach( this, 'date' );
		x.attach( this, 'license' );
		x.attach( this, 'attribution' );
		if( !link.isEmpty() ) { 
			for( e in link ) {
				var l = XMLUtil.createElement( "link", e.content);
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
		x.addChild( tracklist.toXml() );
		return x;
	}
	
	public static function parse( x : Xml ) : Playlist {
//		if( x.get( "version" ) != "1" || x.get( "xmlns" ) != Playlist.NAMESPACE  )
//			throw "Invalid XSPF playlist: "+x.toString();
		var l = new Playlist();
		for( e in x.elements() ) {
			switch( e.nodeName ) {
			case "title" : l.title = e.firstChild().nodeValue;
		    case "creator" : l.creator = e.firstChild().nodeValue;
		    case "annotation" : l.annotation = e.firstChild().nodeValue;
		    case "location" : l.location = e.firstChild().nodeValue;
		    case "info"	: l.info = e.firstChild().nodeValue;
		    case "identifier" : l.identifier =e.firstChild().nodeValue;
		    case "image" : l.image = e.firstChild().nodeValue;
		    case "date"	: l.date = e.firstChild().nodeValue;
		    case "license" : l.license = e.firstChild().nodeValue;
		    case "attribution"	: 
				l.attribution = Xml.createElement( "attribution" );
		    	for( c in e.elements() ) l.attribution.addChild( c );
		   	case "link" : l.link.add( { rel : e.get("rel"), content : e.firstChild().nodeValue } );
		   	case "meta"	: l.meta.add( { rel : e.get("rel"), content : e.firstChild().nodeValue } );
		    case "trackList" : l.tracklist = Tracklist.parse( e );	
			}
		}
		return l;
	}
	
}
