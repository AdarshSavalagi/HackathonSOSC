from django.db import models
from django.contrib.auth.models import User
from .tasks import *
from django_apscheduler.jobstores import DjangoJobStore
from apscheduler.schedulers.background import BackgroundScheduler
from django_apscheduler.jobstores import register_events, register_job


class Customer(models.Model):
    user = models.OneToOneField(User,on_delete=models.CASCADE)
    phone_number = models.CharField(max_length=20)
    Address = models.JSONField(blank=True)
    def __str__(self):
        return self.user.username
    

class Product(models.Model):
    name = models.CharField(max_length=100)
    image = models.ImageField(upload_to='products')
    bidding = models.IntegerField(default=0)
    description = models.TextField()
    maximum_price = models.IntegerField(default=0)
    date = models.DateTimeField(auto_now=True)
    timer = models.SmallIntegerField(default=2)
    is_sold = models.BooleanField(default=False)

    def update_bool_field(self):
        print(f"Product {self.pk} - Setting is_sold to True")
        self.is_sold = True
        self.save()

    def scheduled_job(self):
        print(f"Scheduled job triggered for Product {self.pk}")
        self.update_bool_field()

    def start_scheduler(self):
        print(f"Starting scheduler for Product {self.pk}")
        scheduler = BackgroundScheduler()
        scheduler.add_jobstore(DjangoJobStore(), "default")

        job_id = f"product_{self.pk}_scheduled_job"
        existing_job = scheduler.get_job(job_id)
        if existing_job:
            scheduler.remove_job(job_id)

        scheduler.add_job(
            self.scheduled_job,
            "interval",
            seconds=self.timer*3600,
            id=job_id,
        )

        scheduler.start()
        register_events(scheduler)

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        self.start_scheduler()


    def current(self):
        bid_tag = BidTag.objects.filter(Product=self).order_by('-bid_amount').first()
        if bid_tag:
            return bid_tag.bid_amount
        return 0


class BidTag(models.Model):
    bid_amount = models.IntegerField(default=0)
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    Product = models.ForeignKey(Product,on_delete=models.CASCADE)
    is_accepted = models.BooleanField(default=False)