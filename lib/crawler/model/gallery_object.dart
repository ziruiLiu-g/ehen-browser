
class Gallery {

  String gid = '';
  String gtoken = '';
  String? imgUrl = '';
  String? title = '';
  String? image_count = '';
  String? cata = '';
  Map<String, List<String>> tags = {};
  String? rating = '';
  String? post = '';
  String? hdImgUrl = '';

  Gallery(
      this.gid,
      this.gtoken,
      {this.imgUrl,
      this.title,
      this.image_count,
      this.cata,
      List? tags,
      this.rating,
      String post = '0',
      this.hdImgUrl,
      }) {
    var time = DateTime.fromMillisecondsSinceEpoch(int.parse(post) * 1000);
    this.post = '${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}:${time.second}';

    for (var t in tags!) {

      var tlist = t.split(':');

      var tv = '';
      if (tlist.length > 1) {
        tv = tlist[1];
      } else {
        t = 'other';
        tv = tlist[0];
      }

      if (this.tags.containsKey(tlist[0])) {
        List<String> curList = this.tags[tlist[0]]!;
        curList.add(tv);
        this.tags[tlist[0]] = curList;
      } else {
        this.tags[tlist[0]] = [tv];
      }
    }
  }
}