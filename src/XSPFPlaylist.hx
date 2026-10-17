/**
	The extension element allows non-XSPF XML to be included in XSPF documents.
	The purpose is to allow nested XML, which the meta and link elements do not.
 */
typedef Extension = {
	var application:String;

	/** Element or document fragment; parsed extensions hold all child nodes as a Document. */
	var content:Xml;
}

/**
	The link element allows XSPF to be extended without the use of XML namespaces.
 */
typedef Link = {
	var rel:String;
	var content:String;
}

/**
	The meta element allows metadata fields to be added to xspf:track elements.
	xspf:track elements MAY contain zero or more meta elements.
 */
typedef Meta = {
	var rel:String;
	var content:String;
}

class XSPFTrack {
	/**
		URI of resource to be rendered.
		Probably an audio resource, but MAY be any type of resource with a well-known duration,
		such as video, a SMIL document, or an XSPF document.
		The duration of the resource defined in this element defines the duration of rendering.
		xspf:track elements MAY contain zero or more location elements,
		but a user-agent MUST NOT render more than one of the named resources.
	 */
	public var location:Array<String> = [];

	/**
		Canonical ID for this resource.
			 	Likely to be a hash or other location-independent name, such as a MusicBrainz identifier
			 	or isbn URN (if there existed isbn numbers for audio). MUST be a legal URI.
	 */
	public var identifier:String;

	/**
		Human-readable name of the track that authored the resource which defines the duration of track rendering.
		This value is primarily for fuzzy lookups, though a user-agent may display it.
	 */
	public var title:String;

	/**
		Human-readable name of the entity (author, authors, group, company, etc) that authored the
		resource which defines the duration of track rendering.
		This value is primarily for fuzzy lookups, though a user-agent may display it.
	 */
	public var creator:String;

	/**
		A human-readable comment on the track in text/plain format.
	 */
	public var annotation:String;

	/**
		URI of a place where this resource can be bought or more info can be found.
	 */
	public var info:String;

	/**
		URI of an image to display for the duration of the track.
	 */
	public var image:String;

	/**
		Name of the collection from which the resource which defines the duration of track
		rendering comes. For a song originally published as a part of a CD or LP, this would
			 	be the title of the original release. This value is primarily for fuzzy lookups, though
			  	a user-agent may display it.
	 */
	public var album:String;

	/**
		Integer with value greater than zero giving the ordinal position of the media on the
		xspf:album. This value is primarily for fuzzy lookups, though a user-agent may display it.
		xspf:track elements MAY contain exactly one.
		It MUST be a valid XML Schema nonNegativeInteger.
	 */
	public var trackNum:String;

	/**
		The time to render a resource, in milliseconds.
		It MUST be a valid XML Schema nonNegativeInteger.
		This value is only a hint -- different XSPF generators will generate slightly different
		values. A user-agent MUST NOT use this value to determine the rendering duration, since the
		data will likely be low quality. xspf:track elements MAY contain exactly one duration element.
	 */
	public var duration:Null<Int>;

	/**
	 * The link element allows XSPF to be extended without the use of XML namespaces. 
	 * xspf:track elements MAY contain zero or more link elements.
	 */
	public var link:Array<Link> = [];

	/**
		The meta element allows metadata fields to be added to xspf:track elements.
		xspf:track elements MAY contain zero or more meta elements.
	 */
	public var meta:Array<Meta> = [];

	/**
		The extension element allows non-XSPF XML to be included in XSPF documents.
		The purpose is to allow nested XML, which the meta and link elements do not.
	 */
	public var extension:Array<Extension> = [];

	public function new() {}

	public function toXml():Xml {
		var x = Xml.createElement("track");
		for (l in location)
			x.addChild(XSPFPlaylist.createElement("location", l));
		XSPFPlaylist.attach(x, this, 'identifier');
		XSPFPlaylist.attach(x, this, 'title');
		XSPFPlaylist.attach(x, this, 'creator');
		XSPFPlaylist.attach(x, this, 'annotation');
		XSPFPlaylist.attach(x, this, 'info');
		XSPFPlaylist.attach(x, this, 'image');
		XSPFPlaylist.attach(x, this, 'album');
		XSPFPlaylist.attach(x, this, 'trackNum');
		XSPFPlaylist.attach(x, this, 'duration');
		XSPFPlaylist.addLinks(x, link);
		XSPFPlaylist.addMetas(x, meta);
		XSPFPlaylist.addExtensions(x, extension);
		return x;
	}

	public static function parse(x:Xml):XSPFTrack {
		var t = new XSPFTrack();
		for (e in x.elements()) {
			var v = XSPFPlaylist.text(e);
			switch (XSPFPlaylist.localName(e)) {
				case "location":
					if (v != null)
						t.location.push(v);
				case "identifier":
					t.identifier = v;
				case "title":
					t.title = v;
				case "creator":
					t.creator = v;
				case "annotation":
					t.annotation = v;
				case "info":
					t.info = v;
				case "image":
					t.image = v;
				case "album":
					t.album = v;
				case "trackNum":
					t.trackNum = v;
				case "duration":
					t.duration = (v == null) ? null : Std.parseInt(v);
				case "link":
					t.link.push({rel: e.get("rel"), content: v});
				case "meta":
					t.meta.push({rel: e.get("rel"), content: v});
				case "extension":
					t.extension.push(XSPFPlaylist.parseExtension(e));
			}
		}
		return t;
	}
}

@:allow(XSPFTrack)
class XSPFPlaylist {
	/** XML namespace */
	public static inline var XMLNS = "http://xspf.org/ns/0/";

	/** XSPF playlist version */
	public static inline var VERSION = "1";

	/** The max count of attribution elements */
	public static inline var MAX_ATTRIBUTION = 10;

	/** Title for the playlist. */
	public var title:String;

	/** Name of the entity (author, authors, group, company, etc) that authored the playlist. */
	public var creator:String;

	/**
		A human-readable comment on the playlist.
		This is character data, not HTML, and it may not contain markup. 
		xspf:playlist elements MAY contain exactly one.
	 */
	public var annotation:String;

	/**
		URI of a web page to find out more about this playlist.
		Likely to be homepage of the author, and would be used to find out more about the
		author and to find more playlists by the author.
	 */
	public var info:String;

	/**
		Source URI for this playlist.
		xspf:playlist elements MAY contain exactly one.
	 */
	public var location:String;

	/**
		Canonical ID for this playlist.
		Likely to be a hash or other location-independent name.
		MUST be a legal URI.
		xspf:playlist elements MAY contain exactly one
	 */
	public var identifier:String;

	/**
		URI of an image to display in the absence of a //playlist/trackList/image element.
	 */
	public var image:String;

	/**
		Creation date (not last-modified date) of the playlist, formatted as a <a href=http://www.w3.org/TR/xmlschema-2/#dateTime>XML schema dateTime.</a>
	 */
	public var date:String;

	// public var date(default,setDate) : String; //TODO

	/**
		URI of a resource that describes the license under which this playlist was released. 
	 */
	public var license:String;

	/**
		An ordered list of URIs.
		The purpose is to satisfy licenses allowing modification but requiring attribution.
		If you modify such a playlist, move its //playlist/location or //playlist/identifier
		element to the top of the items in the //playlist/attribution element.
		xspf:playlist elements MAY contain exactly one xspf:attribution element.
		Such a list can grow without limit, so as a practical matter we suggest deleting ancestors
		more than ten generations back.
	 */
	public var attribution:Xml;

	/**
		The link element allows non-XSPF web resources to be included in XSPF documents
		without breaking XSPF validation. 
		xspf:playlist elements MAY contain zero or more link elements.
	 */
	public var link:Array<Link> = [];

	/**
		The meta element allows metadata fields to be added to XSPF.
	 */
	public var meta:Array<Meta> = [];

	/**
		Ordered list of xspf:track elements to be rendered.
		The sequence is a hint, not a requirement; renderers are advised to play tracks from top
		to bottom unless there is an indication otherwise.
		If an xspf:track element cannot be rendered, a user-agent MUST skip to the next xspf:track
		element and MUST NOT interrupt the sequence.
	 */
	// public var tracklist : XSPFTracklist;
	public var tracklist:Array<XSPFTrack> = [];

	/**
		The extension element allows non-XSPF XML to be included in XSPF documents.
		xspf:playlist elements MAY contain zero or more extension elements.
	 */
	public var extension:Array<Extension> = [];

	public function new() {}

	public function toXml():Xml {
		if (tracklist == null)
			throw "Missing trackList element";
		var x = Xml.createElement("playlist");
		x.set("version", VERSION);
		x.set("xmlns", XMLNS);
		XSPFPlaylist.attach(x, this, 'title');
		XSPFPlaylist.attach(x, this, 'creator');
		XSPFPlaylist.attach(x, this, 'annotation');
		XSPFPlaylist.attach(x, this, 'info');
		XSPFPlaylist.attach(x, this, 'location');
		XSPFPlaylist.attach(x, this, 'identifier');
		XSPFPlaylist.attach(x, this, 'image');
		XSPFPlaylist.attach(x, this, 'date');
		XSPFPlaylist.attach(x, this, 'license');
		if (attribution != null)
			x.addChild(copy(attribution));
		addLinks(x, link);
		addMetas(x, meta);
		addExtensions(x, extension);
		var trackList = Xml.createElement("trackList");
		for (t in tracklist)
			trackList.addChild(t.toXml());
		x.addChild(trackList);
		return x;
	}

	public static function parse(x:Xml):XSPFPlaylist {
		var version = x.get("version");
		var i = x.nodeName.indexOf(":");
		var xmlns = (i == -1) ? x.get("xmlns") : x.get("xmlns:" + x.nodeName.substr(0, i));
		if (localName(x) != "playlist" || (version != "0" && version != "1") || xmlns != XMLNS)
			throw "Invalid playlist";
		var l = new XSPFPlaylist();
		for (e in x.elements()) {
			switch (localName(e)) {
				case "title":
					l.title = text(e);
				case "creator":
					l.creator = text(e);
				case "annotation":
					l.annotation = text(e);
				case "location":
					l.location = text(e);
				case "info":
					l.info = text(e);
				case "identifier":
					l.identifier = text(e);
				case "image":
					l.image = text(e);
				case "date":
					l.date = text(e);
				case "license":
					l.license = text(e);
				case "attribution":
					l.attribution = Xml.createElement("attribution");
					for (c in e.elements())
						l.attribution.addChild(copy(c));
				case "link":
					l.link.push({rel: e.get("rel"), content: text(e)});
				case "meta":
					l.meta.push({rel: e.get("rel"), content: text(e)});
				case "extension":
					l.extension.push(parseExtension(e));
				case "trackList":
					for (e in e.elements())
						l.tracklist.push(XSPFTrack.parse(e));
			}
		}
		return l;
	}

	public static function attach(x:Xml, src:Dynamic, name:String) {
		var v = Reflect.field(src, name);
		if (v != null)
			x.addChild(createElement(name, Std.string(v)));
	}

	public static function createElement(name:String, content:String):Xml {
		var x = Xml.createElement(name);
		if (content != null)
			x.addChild(Xml.createPCData(content));
		return x;
	}

	static function addLinks(x:Xml, links:Array<Link>) {
		for (e in links) {
			var l = createElement("link", e.content);
			l.set("rel", e.rel);
			x.addChild(l);
		}
	}

	static function addMetas(x:Xml, metas:Array<Meta>) {
		for (e in metas) {
			var m = createElement("meta", e.content);
			m.set("rel", e.rel);
			x.addChild(m);
		}
	}

	static function addExtensions(x:Xml, extensions:Array<Extension>) {
		for (e in extensions) {
			var t = Xml.createElement("extension");
			t.set("application", e.application);
			if (e.content != null) {
				if (e.content.nodeType == Document) {
					for (c in e.content)
						t.addChild(copy(c));
				} else
					t.addChild(copy(e.content));
			}
			x.addChild(t);
		}
	}

	static function parseExtension(e:Xml):Extension {
		var content = Xml.createDocument();
		for (c in e)
			content.addChild(copy(c));
		return {application: e.get("application"), content: content};
	}

	/** Concatenated text/cdata content of an element, or null if there is none. */
	static function text(x:Xml):String {
		var b:StringBuf = null;
		for (c in x) {
			if (c.nodeType == PCData || c.nodeType == CData) {
				if (b == null)
					b = new StringBuf();
				b.add(c.nodeValue);
			}
		}
		return (b == null) ? null : b.toString();
	}

	/** Element name without namespace prefix. */
	static function localName(x:Xml):String {
		var n = x.nodeName;
		var i = n.indexOf(":");
		return (i == -1) ? n : n.substr(i + 1);
	}

	/** Deep copy, so serializing does not move nodes out of their source document. */
	static function copy(x:Xml):Xml {
		return switch x.nodeType {
			case Element:
				var e = Xml.createElement(x.nodeName);
				for (a in x.attributes())
					e.set(a, x.get(a));
				for (c in x)
					e.addChild(copy(c));
				e;
			case Document:
				var d = Xml.createDocument();
				for (c in x)
					d.addChild(copy(c));
				d;
			case PCData: Xml.createPCData(x.nodeValue);
			case CData: Xml.createCData(x.nodeValue);
			case Comment: Xml.createComment(x.nodeValue);
			case DocType: Xml.createDocType(x.nodeValue);
			case ProcessingInstruction: Xml.createProcessingInstruction(x.nodeValue);
			case _: throw "Unknown node type";
		}
	}
}
