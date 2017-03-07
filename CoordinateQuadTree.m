//
//  CoordinateQuadTree.m
//  AnnotationClustering
//
//  Created by Theodore Calmes on 9/27/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import "CoordinateQuadTree.h"
#import "ClusterMap/ClusterMap-Swift.h"

BoundingBox BoundingBoxForMapRect(MKMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));

    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;

    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;

    return BoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect MapRectForBoundingBox(BoundingBox boundingBox)
{
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));

    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

NSInteger ZoomScaleToZoomLevel(MKZoomScale scale)
{
    double totalTiletMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTiletMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));

    return zoomLevel;
}

float CellSizeForZoomScale(MKZoomScale zoomScale)
{
    NSInteger zoomLevel = ZoomScaleToZoomLevel(zoomScale);

    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
        default:
            return 88;
    }
}

@implementation CoordinateQuadTree

- (QuadTreeNodeData)buildNodeWithPointwithLat:(double)latitude withLong:(double)longitude andID:(int)objectID{
    @autoreleasepool {
            Cluster* cluster = malloc(sizeof(Cluster));
            
            NSString *clusterID = [NSString stringWithFormat:@"%ld", (long)objectID];
            cluster->objectID = malloc(sizeof(int) * clusterID.length + 1);
            strncpy(cluster->objectID, [clusterID UTF8String], clusterID.length + 1);
           return QuadTreeNodeDataMake(latitude, longitude, cluster);
    }
}

- (void)createNodeDataWithCount:(int)count{
    QuadTreeNodeData *dataArray = malloc(sizeof(QuadTreeNodeData) * count);
    _data = dataArray;
}

- (void)addNodeToData:(QuadTreeNodeData)node atIndex:(int)index {
    _data[index] = node;
}

- (void)createRootWithCount:(int)count{
    BoundingBox world = BoundingBoxMake(19, -166, 72, -53);
    _root = QuadTreeBuildWithData(_data, count, world, 4);
}


- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale
{
    double CellSize = CellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / CellSize;

    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);

    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;

            NSMutableArray *ids = [[NSMutableArray alloc] init];

            QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(mapRect), ^(QuadTreeNodeData data) {
                totalX += data.x;
                totalY += data.y;
                count++;
                printf("%d", count);
                
                
                Cluster *cluster = (Cluster *)data.data;
                
                [ids addObject: [NSString stringWithUTF8String:cluster->objectID]];
            });

            if (count == 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                ClusterAnnotation *annotation = [[ClusterAnnotation alloc] initWithCoordinate:coordinate count:count];
                annotation.objectIDs = ids;
                [clusteredAnnotations addObject:annotation];
            }

            if (count > 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                ClusterAnnotation *annotation = [[ClusterAnnotation alloc] initWithCoordinate:coordinate count:count];
                annotation.objectIDs = ids;
                [clusteredAnnotations addObject:annotation];
            }
        }
    }
    return [NSArray arrayWithArray:clusteredAnnotations];
}

@end
