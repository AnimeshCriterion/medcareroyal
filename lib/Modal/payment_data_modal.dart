

class PaymentDataModal{
int? id;
String? paymentMode;
String? image;
bool? isSelected;
  PaymentDataModal({
   this.id,
    this.isSelected,
    this.image,
    this.paymentMode,
});

factory PaymentDataModal.fromJson(Map<String, dynamic> json) =>
    PaymentDataModal(
      id: json['id'],
      isSelected: json['isSelected'],
      image: json['image'],
      paymentMode: json['paymentMode'],
    );
}