this terraform script to create eks cluster doesnot include IAM permission
so after/before creation of eks cluster give iam permission to ur user/group
and not only permission also this terraform script not included rbac that is access entry so after creating cluster goto cluster and manual select access entry(AmazonEKSClusterAdminPolicy) and go back to eks cluster and compute and refresh it then we can see nodes then select role for ur arn.

iam permision(policies)
1.amazoneksclusterpolicy
2.amazoneksworkernodepolicy
3.amazonec2containerregistryreadonly
4.amazonekscnipolicy
5.amazonec2fullaccess
6.administrator access
note:top4 permisiions are mandatory
note:after creating eks ckuster we need to give access entry to iam principal manually so goto eks cluster and click on create access entry(error will be there like iam principan not access to see reources on cluster)and go back to eks cluster and compute and refresh it then we can see nodes


even after u cannot see the nodes in compute area in eks cluster then change manage access to eks API
