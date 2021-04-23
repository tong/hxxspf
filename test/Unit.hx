
import utest.Assert;
import XSPFPlaylist;

class Unit implements utest.ITest {

	static var pl = XSPFPlaylist.parse( Xml.parse( haxe.Resource.getString( "playlist" ) ).firstElement() );

	public function new() {}

	function test_parsePlaylist() {

		Assert.equals( "XSPF Example Playlist", pl.title );
		Assert.equals( "tong", pl.creator );
		Assert.equals( "This is an xspf-playlist example for testing.", pl.annotation );
		Assert.equals( "http:/xspf.org/xspf-v1.html", pl.info );
		Assert.equals( "http:/xspf.disktree.net/xspf_sample.xml", pl.location );
		Assert.equals( "20eabe5d64b0e216796e834f52d61fd0b70332fc", pl.identifier );
		Assert.equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.image );
		Assert.equals( "2008-01-08T17:10:23-05:00", pl.date );
		Assert.equals( "CreativeCommons", pl.license );
		var i = 0;
		for( node in pl.attribution ) {
			switch( i ) {
			case 0 :
				Assert.equals( "location", node.nodeName );
				Assert.equals( "http://disktree.net/modified_version_of_original_playlist.xspf", node.firstChild().nodeValue );
			case 1 :
				Assert.equals( "identifier", node.nodeName );
				Assert.equals( "somescheme:original_playlist.xspf", node.firstChild().nodeValue );
			}
			i++;
		}
		for( link in pl.link ) {
			Assert.equals( "http://disktree.example.org/namespace/version1", link.rel );
			Assert.equals( "http://disktree.net/bar/foo.rdfs", link.content );
		}
		for( meta in pl.meta ) {
			Assert.equals( "duration", meta.rel );
			Assert.equals( "12.5", meta.content );
		}
	}

	function test_parseTracklist() {

		Assert.equals( "ARUK", pl.tracklist[0].title );
		Assert.equals( "http://download.disktree.net/music/tong/ARUK.mp3", pl.tracklist[0].location[0] );
	
		Assert.equals( "arturia_extended_5", pl.tracklist[1].title );
		Assert.equals( "tong", pl.tracklist[1].creator );
		Assert.equals( "http://download.disktree.net/music/tong/arturia_extended_5.mp3", pl.tracklist[1].location[0] );
		Assert.equals( "http://spp.tt4.at", pl.tracklist[1].info );
		Assert.equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.tracklist[1].image );

		Assert.equals( "ybot_e54_4_5", pl.tracklist[2].title );
		Assert.equals( "DJ-mix by ytong at E54 (2005).", pl.tracklist[2].annotation );
		Assert.equals( "http://www.spp.tt4.at", pl.tracklist[2].info );
		Assert.equals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", pl.tracklist[2].location[0] );
		Assert.equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.tracklist[2].image );
		Assert.equals( "http://disktree.example.org/namespace/version1", pl.tracklist[2].link[0].rel );
		Assert.equals( "http://disktree.net/bar/foo.rdfs", pl.tracklist[2].link[0].content );

		Assert.equals( "captions", pl.tracklist[2].meta[0].rel );
		Assert.equals( "http://disktree.net/path.xml", pl.tracklist[2].meta[0].content );

		Assert.equals( "http://example.com", pl.tracklist[2].extension[0].application );
		//TODO Assert.equals( '<cl:clip start="25000" end="34500" />', pl.tracklist[2].extension[0].content.toString() );

		/*
		var i = 0;
		for( track in pl.tracklist ) {
			switch( i ) {
			case 0 :
				Assert.equals( "ARUK", track.title );
				Assert.equals( "http://download.disktree.net/music/tong/ARUK.mp3", track.location[0] );

			case 1 :
				Assert.equals( "arturia_extended_5", track.title );
				Assert.equals( "tong", track.creator );
				Assert.equals( "http://download.disktree.net/music/tong/arturia_extended_5.mp3", track.location[0] );
				Assert.equals( "http://spp.tt4.at", track.info );
				Assert.equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", track.image );

			case 2 :
				Assert.equals( "ybot_e54_4_5", track.title );
				Assert.equals( "DJ-mix by ytong at E54 (2005).", track.annotation );
				Assert.equals( "http://www.spp.tt4.at", track.info );
				Assert.equals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", track.location[0] );
				Assert.equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", track.image );
				var j = 0;
				for( link in track.link ) {
					Assert.equals( "http://disktree.example.org/namespace/version1", link.rel );
					Assert.equals( "http://disktree.net/bar/foo.rdfs", link.content );
					j++;
				}
				j = 0;
				for( meta in track.meta ) {
					switch( j ) {
						case 0 :
							Assert.equals( "captions", meta.rel );
							Assert.equals( "http://disktree.net/path.xml", meta.content );
						case 1 :
							Assert.equals( "audio", meta.rel );
							Assert.equals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", meta.content );
						case 2 :
							Assert.equals( "duration", meta.rel );
							Assert.equals( "00:00:45", meta.content );
					}
					j++;
				}
				j = 0;
				for( extension in track.extension ) {
					Assert.equals( "http://example.com", extension.application );
					Assert.equals( Xml.parse( '<cl:clip start="25000" end="34500"/>' ).toString(), extension.content.toString() );
				}
			}
			i++;
		}
		*/
	}

	static function main() {
		var runner = new utest.Runner();
		runner.addCase( new Unit() );
		var report = utest.ui.Report.create( runner );
		runner.run();
	}

}
