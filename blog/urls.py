from django.urls import re_path
from django.contrib.auth import views as auth_views

from . import views

urlpatterns = [
    re_path(r'^$', views.post_list, name='post_list'),

    # Django 2.1+ uses 'LoginView.as_view()' instead of 'auth_views.login'
    re_path(r'^login/$', auth_views.LoginView.as_view(template_name='blog/login.html'), name='login'),

    re_path(r'^post/(?P<pk>\d+)/$', views.post_detail, name='post_detail'),
    re_path(r'^post/(?P<pk>\d+)/edit/$', views.post_edit, name='post_edit'),
    re_path(r'^post/new/$', views.post_new, name='post_new'),
]
