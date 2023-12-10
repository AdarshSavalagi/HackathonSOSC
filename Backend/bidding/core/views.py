from rest_framework.views import Response,APIView
from rest_framework import  permissions, status
from rest_framework_simplejwt.authentication import JWTAuthentication
from .models import *
from .serializers import *
from rest_framework import status
from django.core.exceptions import ObjectDoesNotExist

from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User

class PublicView(APIView):
    authentication_classes = []
    permission_classes = [permissions.AllowAny]
    def post(self, request):
        username = request.data.get('username', '')
        password = request.data.get('password', '')
        phone = request.data.get('phone', '')
        address = request.data.get('address', '')
        landmark = request.data.get('landmark', '')
        name = request.data.get('name', '')
        if not (username and password and phone and name):
            return Response({'message': 'Incomplete data'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            userobj = User.objects.create_user(username=username, password=password, first_name=name)
            add = {'address': address, 'landmark': landmark}
            customer = Customer(user=userobj, phone_number=phone, Address=add)
            customer.save()
            token, _ = Token.objects.get_or_create(user=userobj)
            return Response({'access': token.key})
        except Exception as e:
            return Response({'message': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class IndexView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        products = Product.objects.all()
        serialized_data = ProductSerializer(products, many=True).data
        return Response(data={'products': serialized_data})

    def post(self, request):
        try:
            product_id = request.data.get('pid')
            new_amount = int(request.data.get('new_amount', '0'))
            bid_type = request.data.get('type', '')

            if not (product_id and new_amount and bid_type):
                return Response({'message': 'Incomplete data'}, status=status.HTTP_400_BAD_REQUEST)

            product = Product.objects.filter(id=product_id).first()

            if not product:
                return Response({'message': 'Product not found'}, status=status.HTTP_404_NOT_FOUND)

            if bid_type == '1':
                obj = BidTag(user=request.user, bid_amount=new_amount, Product=product)
                obj.save()
                return Response({'message': 'Success'})
            else:
                return Response({'message': 'Invalid bid type'}, status=status.HTTP_400_BAD_REQUEST)

        except ValueError:
            return Response({'message': 'Invalid input for new_amount'}, status=status.HTTP_400_BAD_REQUEST)
        except ObjectDoesNotExist:
            return Response({'message': 'Object does not exist'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'message': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


