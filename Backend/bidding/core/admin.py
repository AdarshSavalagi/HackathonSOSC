from django.contrib import admin
from .models import *
from django.utils.html import format_html




class ProductAdmin(admin.ModelAdmin):
    search_fields = ['name' ]
    list_display = ['name',  'display_image','bidding','maximum_price','current','date',]

    def display_image(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="50" height="50" /> ', obj.image.url)
        return "No Photo"

    display_image.short_description = 'Image'


admin.site.register(Customer,)
admin.site.register(Product,ProductAdmin)
admin.site.register(BidTag)
