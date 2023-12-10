from rest_framework import serializers
from .models import *
from django.db.models import Max
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields='__all__'

class CustomerSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    class Meta:
        model = Customer
        fields='__all__'


class ProductSerializer(serializers.ModelSerializer):
    current = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = '__all__'

    def get_current(self, obj):
        bid_tags = BidTag.objects.filter(Product=obj)
        if bid_tags.exists():
            max_bid = bid_tags.aggregate(max_bid_amount=Max('bid_amount'))
            return max_bid.get('max_bid_amount', 0)
        return obj.bidding



class BidTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = BidTag
        fields='__all__'