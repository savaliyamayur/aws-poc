import boto3

def import_ami_to_workspaces(ami_id, image_name, image_description, applications=[]):
    # Replace with your AWS region
    aws_region = 'us-west-2'

    # Initialize the AWS WorkSpaces client
    workspaces_client = boto3.client('workspaces', region_name=aws_region)

    try:
        # Start the image import process
        response = workspaces_client.import_workspace_image(
            Ec2ImageId=ami_id,
            IngestionProcess='BYOL_WORKSPACE',
            ImageName=image_name,
            ImageDescription=image_description,
            Applications=applications  # Remove this line if you don't want to specify applications
        )
        image_id = response['ImageId']
        print(f"Image import started. Image ID: {image_id}")

        # Wait for the import process to complete
        waiter = workspaces_client.get_waiter('workspace_image_available')
        waiter.wait(
            Name=image_name,
            ImageIds=[image_id],
            WaiterConfig={
                'Delay': 60,
                'MaxAttempts': 60
            }
        )
        print(f"Image import completed. Image ID: {image_id}")

    except Exception as e:
        print(f"Error starting or waiting for image import: {str(e)}")

# Usage example
if __name__ == "__main__":
    ami_id = 'ami-08997b44f5c728516'  # Replace with your EC2 AMI ID
    image_name = 'MyImportedImage'  # Provide a name for the imported image
    image_description = 'Description for MyImportedImage'  # Provide a description
    applications = []  # Remove this line if you don't want to specify applications

    import_ami_to_workspaces(ami_id, image_name, image_description, applications)
