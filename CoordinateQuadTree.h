//
//  CoordinateQuadTree.h
//  AnnotationClustering
//
//  Created by Theodore Calmes on 9/27/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuadTree.h"
#import <MapKit/MapKit.h>
#include "Cluster.h"

@interface CoordinateQuadTree : NSObject

@property (assign, nonatomic) QuadTreeNode* root;
@property (strong, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) QuadTreeNodeData* data;

- (QuadTreeNodeData)buildNodeWithPointwithLat:(double)latitude withLong:(double)longitude andID:(int)objectID;
- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;
- (void)addNodeToData:(QuadTreeNodeData)node atIndex:(int)index;
- (void)createRootWithCount:(int)count;
- (void)createNodeDataWithCount:(int)count;

@end
