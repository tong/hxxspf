package xspf;

class Tracklist extends List<Track> {
	
	public function toXml() : Xml {
		var x = Xml.createElement( "trackList" );
		for( t in iterator() )
			x.addChild( t.toXml() );
		return x;
	}
	
	public static function parse( x : Xml ) : Tracklist {
		var l = new Tracklist();
		for( e in x.elements() )
			l.add( Track.parse( e ) );
		return l;
	}
	
}
