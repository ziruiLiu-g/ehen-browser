class VideoGalleryModel {
  String? vid = '';
  String? imgUrl = '';
  String? mp4 = '';
  String? videoPageLink = '';
  String? title = '';
  String? like_count = '';
  String? watch = '';
  String? duration = '';
  String? m3u8 = '';
  List<VideoStarModel> stars = [];
  List<VideoCataModel> catas = [];

  VideoGalleryModel(
      {this.vid, this.imgUrl, this.mp4, this.videoPageLink, this.title, this.like_count, this.watch, this.duration, this.m3u8});
}

class VideoStarModel {
  String? name;
  String? avatarUrl;
  String? webpage;
  String? videoNum;

  VideoStarModel(this.name, this.avatarUrl, this.webpage, {this.videoNum});
}

class VideoCataModel {
  String? name;
  String? url;
  String? level;

  VideoCataModel(this.name, this.url, this.level);
}