class MenuModel {
  String? foodCode;
  String? name;
  String? picture;
  String? pictureOri;
  String? createdAt;
  int? id;

  MenuModel(
      {this.foodCode,
        this.name,
        this.picture,
        this.pictureOri,
        this.createdAt,
        this.id});

  MenuModel.fromJson(Map<String, dynamic> json) {
    foodCode = json['food_code'];
    name = json['name'];
    picture = json['picture'];
    pictureOri = json['picture_ori'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_code'] = foodCode;
    data['name'] = name;
    data['picture'] = picture;
    data['picture_ori'] = pictureOri;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}