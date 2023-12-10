# scheduler.py

from apscheduler.schedulers.background import BackgroundScheduler
from django_apscheduler.jobstores import DjangoJobStore
from django_apscheduler.jobstores import register_events, register_job

def start():
    scheduler = BackgroundScheduler()
    scheduler.add_jobstore(DjangoJobStore(), "default")
    
    # Register your job
    @register_job(scheduler, "interval", minutes=15)
    def scheduled_job():
        your_function_to_schedule()  # Call the function you want to run periodically
    
    # Start the scheduler
    scheduler.start()
    register_events(scheduler)
