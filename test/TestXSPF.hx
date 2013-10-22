
import XSPFPlaylist;

class TestXSPF extends haxe.unit.TestCase {
	
	static var pl = XSPFPlaylist.parse( Xml.parse( haxe.Resource.getString( "playlist" ) ).firstElement() );

	public function testParsePlaylist() {

		assertEquals( "XSPF Example Playlist", pl.title );
		assertEquals( "tong", pl.creator );
		assertEquals( "This is an xspf-playlist example for testing.", pl.annotation );
		assertEquals( "http:/xspf.org/xspf-v1.html", pl.info );
		assertEquals( "http:/xspf.disktree.net/xspf_sample.xml", pl.location );
		assertEquals( "20eabe5d64b0e216796e834f52d61fd0b70332fc", pl.identifier );
		assertEquals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.image );
		assertEquals( "2008-01-08T17:10:23-05:00", pl.date );
		assertEquals( "CreativeCommons", pl.license );
		var i = 0;
		for( node in pl.attribution ) {
			switch( i ) {
			case 0 :
				assertEquals( "location", node.nodeName );
				assertEquals( "http://disktree.net/modified_version_of_original_playlist.xspf", node.firstChild().nodeValue );
			case 1 :
				assertEquals( "identifier", node.nodeName );
				assertEquals( "somescheme:original_playlist.xspf", node.firstChild().nodeValue );
			}
			i++;
		}
		for( link in pl.link ) {
			assertEquals( "http://disktree.example.org/namespace/version1", link.rel );
			assertEquals( "http://disktree.net/bar/foo.rdfs", link.content );
		}
		for( meta in pl.meta ) {
			assertEquals( "duration", meta.rel );
			assertEquals( "12.5", meta.content );
		}
	}
		
	public function testParseTracklist() {

		var i = 0;
		for( track in pl.tracklist ) {
			switch( i ) {
			case 0 :
				assertEquals( "ARUK", track.title );
				assertEquals( "http://download.disktree.net/music/tong/ARUK.mp3", track.location.first() );
				
			case 1 :
				assertEquals( "arturia_extended_5", track.title );
				assertEquals( "tong", track.creator );
				assertEquals( "http://download.disktree.net/music/tong/arturia_extended_5.mp3", track.location.first() );
				assertEquals( "http://spp.tt4.at", track.info );
				assertEquals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", track.image );
				
			case 2 :
				assertEquals( "ybot_e54_4_5", track.title );
				assertEquals( "DJ-mix by ytong at E54 (2005).", track.annotation );
				assertEquals( "http://www.spp.tt4.at", track.info );
				assertEquals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", track.location.first() );
				assertEquals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", track.image );
				var j = 0;
				for( link in track.link ) {
					assertEquals( "http://disktree.example.org/namespace/version1", link.rel );
					assertEquals( "http://disktree.net/bar/foo.rdfs", link.content );
					j++;
				}
				j = 0;
				for( meta in track.meta ) {
					switch( j ) {
						case 0 :
							assertEquals( "captions", meta.rel );
							assertEquals( "http://disktree.net/path.xml", meta.content );
						case 1 :
							assertEquals( "audio", meta.rel );
							assertEquals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", meta.content );
						case 2 :
							assertEquals( "duration", meta.rel );
							assertEquals( "00:00:45", meta.content );
					}
					j++;
				}
				j = 0;
				for( extension in track.extension ) {
					assertEquals( "http://example.com", extension.application );
					assertEquals( Xml.parse( '<cl:clip start="25000" end="34500"/>' ).toString(), extension.content.toString() );
				}
			}
			i++;
		}
	}
	
	static function main() {
		var r = new haxe.unit.TestRunner();
		r.add( new TestXSPF() );
		r.run();
	}
	
}
